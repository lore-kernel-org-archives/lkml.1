Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZGWGZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZGWGZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZGWGZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:25:00 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:33060 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZGWGY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SI1iQ5n5kZPLIKYXMx6tlC30Ek9uWP+E1/69XnHrieQxrKLxdI4VYsk7KOaLRhQ18G
         hmj5Uh3KfQc2/1vQ0MBxGGzNxaDmb9UNSkbaNlO7B5uq2zCtFA2AKpFP4cm4rVnzbSpX
         BpnnGvch0UQJM+eCCHzP3kzQo3fQwsLaVbT2o=
MIME-Version: 1.0
In-Reply-To: <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
	 <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
	 <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
Date: Thu, 23 Jul 2009 08:24:58 +0200
Message-ID: <d8bd05e00907222324q26b8faa0i2d85f4d7e35d8198@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See my original post to LKML at http://lkml.org/lkml/2009/7/15/217.
You can see kernel version, and dmesg output (including cifsFYI set to
7) there.
I did file a bug report to gentoo bug list and lkml. Shall I also do
so for bugzilla.samba.org ? I think it's more kernel related.

The DebugData of the share I'm trying to mount (fortunaltely I got a
successful mount after several tries):

brklev2b ~ # cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.57
Active VFS Requests: 0
Servers:
1) Name: 10.5.12.105  Domain: EUROPE Uses: 1 OS: Windows Server 2003
R2 3790 Service Pack 1
        NOS: Windows Server 2003 R2 5.2 Capability: 0x1f3fd
        SMB session status: 1   TCP status: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\BRKVN05\AtlasPM Mounts: 1 Type: NTFS DevInfo: 0x20
Attributes: 0x700ff
PathComponentMax: 255 Status: 0x1 type: DISK    DISCONNECTED

        MIDs:


Gerhard

On Thu, Jul 23, 2009 at 8:10 AM, Steve French<smfrench@gmail.com> wrote:
> On Thu, Jul 23, 2009 at 12:26 AM, Gerhard
> Hintermayer<gerhard.hintermayer@gmail.com> wrote:
>> Well this is indeed strange. First I thought the problem was solved
>> because I had an old version of mount installed, but the successful
>> mount with latest version of mount.cifs was only by chance. I get 1
>> successful mount out of ~ 30 tries (each time unloading the cifs
>> module). And looking at the source in export.c I discovered, that
>> reexporting cifs- mount points is still not supported :-( : This seems
>> to be very tricky. If you need more information to track the tainting
>> problem down, pls give me a note.
>
> What is kernel version?
> What is symptom?
>
> Have you opened a bug against the project bugzilla (bugzilla.samba.org)?
>
> The dmesg (Linux message log) will show certain serious errors, but
> enabling additional cifs debugging flags can increase the debug
> output. Setting /proc/fs/cifs/DebugData to 1 will cause additional
> cifs informational messages to be logged, and setting
> it to 3 (“echo 3 > /proc/fs/cifs/cifsFYI”) will also log return codes
> from most cifs entry points to dmesg.
> One of the most powerful tools for analyzing networking or network
> filesystem problems is “Wireshark."
> http://wiki.samba.org/index.php/Capture_Packets shows instructions how
> to do wireshark captures.
>
> --
> Thanks,
>
> Steve
>
