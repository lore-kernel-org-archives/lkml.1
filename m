Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYHQWan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYHQWan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHQWaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:30:35 -0400
Received: from mail.lang.hm ([64.81.33.126]:37206 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYHQWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:30:34 -0400
Date: Sun, 17 Aug 2008 15:30:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: rmeijer@xs4all.nl, Peter Dolding <oiaohm@gmail.com>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <20080817215822.GA21112@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.1.10.0808171524350.12859@asgard.lang.hm>
References: <6746.82.95.100.23.1218969200.squirrel@webmail.xs4all.nl> <alpine.DEB.1.10.0808170345300.12859@asgard.lang.hm> <20080817215822.GA21112@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, Pavel Machek wrote:

>>>> you are arguing with the wrong people here. we are not trying to define
>>>> the future of anti-virus technologies, we are trying to figure out how to
>>>> provide the hooks so that people and companies can go off and do the
>>>> research and experimentation and try different approaches.
>>>
>>> Given recent demonstrations that show how easy it apparently is to bypass
>>> blacklist base approaches, providing hooks to allow these blacklist
>>> approaches may I feel be rather futile. Focusing only on hooks for white
>>> list approaches in combination with hooks for least authority approaches
>>> like the powerbox would IMHO seem like a much more reasonable approach
>>> given the current state of things and knowledge concerning the blacklist
>>> technologies. Explicitly adding support for technology that is quickly
>>> becoming obsolete would seem like a waste of time and resources.
>>
>> we are not providing hooks for blacklists or whitelists, we are providing
>> hooks for scanning. it's up to the software that doesn the scanning to
>> implement the blacklist or whitelist.
>
> Actually, I don't think so.
>
> If we wanted to whitelist permitted binaries, approach would be
> something like "lets sign them"... and it seems IBM is working on
> something like that with TPM infrastructure.

the structure I proposed would support this as well.

your 'scanner' program would do the signature and store it somewhere and 
mark the file as being scanned.

on access the checking software would see that you have marked it as being 
scanned and can avoid the overhead of reading the entire file to check 
it's signature (or you can configure it to do the full check again)

if the file gets written to the tag would get cleared and the file would 
not be used without being blessed by your scanner again (and your scanner 
my bless it if what happened was an OS update where the new file matches a 
known signature)

not quite as straightforward as you were probably thinking (you were 
probably thinking somthing like 'store the signature and have the kernel 
check it each time the file is opened'), but this would have the option of 
being faster by skipping the signature check if the file was tagged as 
already being checked.

David Lang
