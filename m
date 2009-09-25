Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZIYTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZIYTqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZIYTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:46:48 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:57725 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZIYTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:in-reply-to:message-id:references:user-agent
         :x-archive:mime-version:content-type;
        b=SIenJwv6jDWwJRKyeZxbP6CrKPgMQdvjPrLu8uTenul+3lzeW1vMHQnJDZaVQO5ocI
         NHyYhPk0Jyc+a22Apns0LMPbODJPWomC/EsWiVhVEuGcGIh61iFNAfRKlgKL0o8n5VfB
         +KYDqBWbxh1jZT79+W5WSsqj5hoMwlRZOZAP4=
Date: Fri, 25 Sep 2009 16:46:45 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due
 to  commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
In-Reply-To: <b6a2187b0909250932r140eca54y75b38634b853bb9@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.0909251638540.5332@dyndns.pervalidus.net>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>  <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>  <b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>  <20090925115636.5b4b8aca@linux.intel.com> 
 <b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com>  <20090925164747.55dab000@lxorguk.ukuu.org.uk>  <4ABCE72D.5040001@xenotime.net>  <b6a2187b0909250900n7922f606w8b99f042b0a6f441@mail.gmail.com>
 <b6a2187b0909250932r140eca54y75b38634b853bb9@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009, Jeff Chua wrote:

> On Sat, Sep 26, 2009 at 12:00 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> On Fri, Sep 25, 2009 at 11:52 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> Alan Cox wrote:
>>>>> Is this going into Linus's branch soon? Otherwise, please kindly post
>>>>> the full patch so that I can test it instead of pulling 400MB from
>>>>> Andrew's tree.
>>>> I don't have Andrews tty patches here either sorry but I thought he kept
>>>> them broken out on kernel.org ?
>>> http://userweb.kernel.org/~akpm/mmotm/
>>> see the broken-out/ subdir.
>>
>> I see. But that patch is not there. Did find it on google.
>>
>> http://www.spinics.net/lists/mm-commits/msg71772.html
>>
>> So, I'll test it now.
>
> Alan, Randy,
>
> That patch works!
>
> Thanks,
> Jeff

Here, it doesn't fix 
http://marc.info/?l=linux-kernel&m=125382651922142&w=2

But I found something in syslog:

Sep 25 16:17:31 pervalidus agetty[1465]: /dev/tty2: No such file or directory
Sep 25 16:17:31 pervalidus agetty[1464]: /dev/tty1: No such file or directory
Sep 25 16:17:31 pervalidus agetty[1466]: /dev/tty3: No such file or directory
...

So, why it works with 2.6.30.7 and not 2.6.30.1 ?

And I also noticed that it takes longer with 2.6.30.7 than 
before for the login and password prompts to appear.

In /etc/inittab, I have

c1:1235:respawn:/sbin/agetty 38400 tty1 linux
c2:1235:respawn:/sbin/agetty 38400 tty2 linux
c3:1235:respawn:/sbin/agetty 38400 tty3 linux
c4:1235:respawn:/sbin/agetty 38400 vc/4 linux (yes, nothing 
about vc/4 in the logs)

So, with 2.6.30, udev doesn't create the symlinks from vc/*, or 
it's something in the kernel that prevents it ?
