Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZAFGcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZAFGcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZAFGcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:32:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:4048 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZAFGcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L+QhsGmpVKKSkD/1v46KZ2UH8rDf1cLWvQQOzy9ySx1ujsmtpExN7W6yweSe4GITXU
         dWXrDpcRKipq46KLGtnrGELyyDeKSnTjRH0Y2sqzCXYN1BFRDNCE4e6dG4cvVmRYrRVx
         lSs59G6kmYg7Cx/Py3nEfC+lUr99kQhBvl8BU=
Message-ID: <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com>
Date: Tue, 6 Jan 2009 01:32:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: debugfs & vfs file permission issue?
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090106061946.GA10026@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901052157.07306.rgetz@blackfin.uclinux.org>
	 <20090106054858.GA9040@suse.de>
	 <8bd0f97a0901052154w213f9a03oafdd07645b1b7dc7@mail.gmail.com>
	 <20090106061946.GA10026@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 01:19, Greg KH wrote:
> On Tue, Jan 06, 2009 at 12:54:58AM -0500, Mike Frysinger wrote:
>> On Tue, Jan 6, 2009 at 00:48, Greg KH wrote:
>> > On Mon, Jan 05, 2009 at 09:57:07PM -0500, Robin Getz wrote:
>> >> On 2.6.28-rc2, If I create a debugfs file with
>> >>
>> >>     debugfs_create_x16("SPORT1_TX", 0200 , parent, 0xFFC00910);
>> >
>> > Um, are you are passing in a pointer to a known memory location
>> > properly?  Why would it be ok for the kernel to directly read that
>> > location?
>>
>> it's a nommu system and the 0xffc00000+ addresses are always available
>
> Writable but not readable?  Isn't hardware fun :)

yeah and we have some readable but not writable addresses too :/

>> >> Although the file shows up as write only (no read):
>> >>
>> >> root:/> ls -l /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
>> >> --w-------    1 root     root            0 Jan  1
>> >> 2007 /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
>> >>
>> >> root:/> cat /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
>> >>
>> >> Still works - and causes the read to occur, which crashes :(
>> >
>> > You're root, you can do anything :)
>>
>> any thoughts on how to declare debugfs files that are read or write
>> only ?  we'll have to add new helper functions or have it be a
>> parameter or declare our own debugfs file ?
>
> Just use debugfs_create_file() and use your own read/write functions to
> prevent a read or write from happening no matter what.  No new debugfs
> infrastructure should be needed.

would it be useful for this to be a common function ?  probably not so
much considering (i'm assuming) no one else has asked so far for such
a beast ...
-mike
