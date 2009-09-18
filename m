Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZIRVT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZIRVT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZIRVT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:19:27 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:21424 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZIRVT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0909181407370.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <m1ab0tcwep.fsf@fess.ebiederm.org> 
	<20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> 
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> 
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> 
	<alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> 
	<1253238637.4071.10.camel@yio.site> <m14or0vul4.fsf@fess.ebiederm.org> 
	<alpine.LFD.2.01.0909181407370.4950@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 23:19:15 +0200
Message-ID: <ac3eb2510909181419p4a9fa382pc93c81aaa871e80c@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 23:09, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, 18 Sep 2009, Eric W. Biederman wrote:
>>
>> As a special case you can implement this much
>> more simply in devtmpfs_mount just do:
>>
>> int devtmpfs_mount(const char *mountpoint)
>> {
>>         sys_mount("none", "dev", "devtmpfs", MS_SILENT, NULL);
>>       sys_chmod("dev/console", 0666);
>>       sys_chmod("dev/tty", 0666);
>>       sys_chmod("dev/null", 0666);
>>       sys_chmod("dev/zero", 0666);
>> }
>
> Yeah, I think that's the way to go.

Are we sure about console? It's not what udev does today, it stays as 0600.

Kay
