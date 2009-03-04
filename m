Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZCDA0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZCDA0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZCDA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:26:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:16946 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbZCDA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:26:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:date
         :in-reply-to:message-id:lines:user-agent:mime-version:content-type;
        b=txBfnkt+dxdSTLj4ajzQSS5Ca0mauCB7NQ9mnNnrIPPrlf25MqiQSYSAF5O3Xu2oNM
         ZfupWLfWxEyer0ext7+GcXQTYHqGkE31raNBTtIgJyeevrE2XJvNtnETkhJ7uJsJ9OKl
         FnL0cugH2bWHqnr5BpyO2ZKpAV5jDpttZhzm8=
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
References: <49A98F6A.50702@gmail.com> <1235886467.3195.15.camel@mj>
	<49AD7E2B.3010101@gmail.com>
From: Jakub Narebski <jnareb@gmail.com>
Date: Tue, 03 Mar 2009 16:26:28 -0800 (PST)
In-Reply-To: <49AD7E2B.3010101@gmail.com>
Message-ID: <m3iqmqt9ox.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave <kilroyd@googlemail.com> writes:

> Adding the git mailing list.
> 
> Pavel Roskin wrote:
> > On Sat, 2009-02-28 at 19:24 +0000, Dave wrote:

>>> I'm aware of at least a couple users of orinoco who have picked up
>>> corrupt firmware# from the linux-firmware tree*.
>>>
>>> I've verified that the firmware in the repository itself is correct.
>>>
>>> It appears that downloading the file using the blob/raw links from
>>> gitweb causes the corruption (0xc3 everywhere). At least it does with
>>> firefox.
>> 
>> I can confirm the problem with Firefox 3.0.6.  But it's not "0xc3
>> everywhere".  The corrupted file is a result of recoding from iso-8859-1
>> to utf-8.  The correct agere_sta_fw.bin is 65046 bytes long.  The
>> corrupted agere_sta_fw.bin is 89729 bytes long.

[...]
>> My strong impression is that the recoding takes place on the server.  I
>> think the bug should be reported to the gitweb maintainers unless it a
>> local breakage on the kernel.org site.
> 
> Thanks Pavel.
> 
> I just did a quick scan of the gitweb README - is this an issue with the
> $mimetypes_file or $fallback_encoding configurations variables?

First, what version of gitweb do you use? It should be in 'Generator'
meta header, or (in older gitweb) in comments in HTML source at the
top of the page.

Second, the file is actually sent to browser 'as is', using binmode :raw
(or at least should be according to my understanding of Perl). And *.bin
binary file gets application/octet-stream mimetype, and doesn't send any
charset info. git.kernel.org should have modern enough gitweb to use this.
Strange...

-- 
Jakub Narebski
Poland
ShadeHawk on #git
