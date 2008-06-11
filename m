Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYFKCAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYFKCAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYFKCAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:00:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:64434 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbYFKCAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BRcCz8LUPTYXusqbh4YbGKA5TNvwumHz33ZLS2bnK/Y95kc9HpKD6/34DKtD5UCElC
         3r5jkS81jReQfwZdBOCkIksqYmYd1Axc8V/bE70sH/UPty6I8dw9PQzwr3ZtGVLzCX4/
         9u44x+BB4wv0qZTeEDWfc7T7k0J60laQ8Yh4o=
Message-ID: <484F31B8.8030001@gmail.com>
Date: Wed, 11 Jun 2008 11:00:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Justin Mattock <justinmattock@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com> <20080404012147.abf8a598.akpm@linux-foundation.org>
In-Reply-To: <20080404012147.abf8a598.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 4 Apr 2008 05:07:45 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
> 
>> When playing a DVD and then suspending the system while the DVD is
>> still in play, upon wakeup I'm receiving a Buffer I/O error on device
>> sr0, logical block 356490.
>> the DVD will continue to play but then gmplayer complains: Warning!
>> FPS changed 23.976 -> 29.970 (-5.994005) [4] then the video becomes
>> very choppy. When looking at osx in the same test the DVD will be
>> paused until the cd player aligns itself, then playback will start.
>> With looking further at this I think this is an issue of a library or
>> codec, So with this in mind is there a package that I might look at to
>> see if this resolves the issue. Attached is dmesg of the Buffer I/O
>> regards;
> 
> An ata thing, I assume.  Let's cc linux-ide.
> 
> Is this new behaviour in 2.6.25-rc8, or were earlier kernels OK?

This is due to UNIT ATTENTION condition triggered by reset during
resume.  The following patches should fix it.

http://marc.info/?l=linux-ide&m=121309016918976&w=2
http://marc.info/?l=linux-ide&m=121309016918979&w=2

Thanks.

-- 
tejun
