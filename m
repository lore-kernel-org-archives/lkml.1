Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088Ab0AZGBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0AZGBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828Ab0AZGBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:01:13 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:55273 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0AZGBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pJ8IZAJVVn5j6XNLY9BWnEn793QniZxQ+2C0QccHnMnsvdS75XOh16zGeWYcozeXQ8
         a5cZ/8E0/+qNkS4H/iI1/uq/ksW+gb3dIDRPFvqw4jDgEaACePLb1PqibJG4TRnHIJ6F
         QBJD7D38X7P+7QgzLNyuHT4uZWzHbaz9fnwuY=
MIME-Version: 1.0
In-Reply-To: <20100126144641.5AB3.A69D9226@jp.fujitsu.com>
References: <2375c9f91001252125w6f5bd3d3he183c61e9dcedd3e@mail.gmail.com>
	 <20100126142644.5AB0.A69D9226@jp.fujitsu.com>
	 <20100126144641.5AB3.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Jan 2010 14:01:12 +0800
Message-ID: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 1:49 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > On Tue, Jan 26, 2010 at 11:20 AM, KOSAKI Motohiro
>> > <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > > Hi
>> > >
>> > > Current linus tree made following lockdep warning when starting emacs command.
>> > > Is this known issue?
>> > >
>> > >
>> > > =========================================================
>> > > [ INFO: possible irq lock inversion dependency detected ]
>> > > 2.6.33-rc5 #77
>> > > ---------------------------------------------------------
>> > > emacs/1609 just changed the state of lock:
>> > >  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
>> > > but this lock took another, HARDIRQ-unsafe lock in the past:
>> > >  (&(&sighand->siglock)->rlock){-.....}
>> > >
>> > > and interrupts could create inverse lock ordering between them.
>> > >
>> > >
>> >
>> > Hey,
>> >
>> > does reverting commit 703625118 help?
>>
>> Seems solved.
>>
>> Thanks.
>
> I'm sorry.
> I forgot to cc related person at last mail.
>
> Greg, can you please consider revert commit 703625118?
>

I agree, it seems that patch is useless, since we already
do lock_kernel() before calling __f_setown()...
