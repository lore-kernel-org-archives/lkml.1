Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZAMNcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZAMNcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbZAMNcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:32:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:24869 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbZAMNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Bbb4HMg4+87LNj2LqX0DlsYEKul5lSch8q/bAhIjpeCSw56n8Zo+yjnkGzweePSRn9
         Nl5OKLu+peQc6ZPt+0gnPQvrEwczYD91AwQVQUrDNGNXgTV0cqAeOfaKpxkNSELV/GF/
         n90wrBddsnoBWEB/b43YgcrH9H2OksL2x7YAo=
Message-ID: <496C97F1.9000502@panasas.com>
Date: Tue, 13 Jan 2009 15:32:33 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Avishay Traeger <avishay@gmail.com>,
       open-osd development <osd-dev@open-osd.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org>	<1231802758.27151.18.camel@localhost.localdomain>	<496C9109.5040803@panasas.com> <496C9617.80701@garzik.org>
In-Reply-To: <496C9617.80701@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 13, 2009, 15:24 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Benny Halevy wrote:
>> IMO the main advantage of moving block allocation down to the OSD target
>> is more apparent with distributed file systems a-la pNFS over objects
>> where paralleling that task is a key for scalable performance.
>>
>> The thing is that the target needs to implement its own mapping from
>> object logical offsets into disk blocks and this is usually done
>> using some kind of a (possibly trimmed down) local file system.
>> Therefore the I/O performance of a single OSD is likely to be similar
>> to a single file server's.
> 
> Well, modern SATA devices are already mini-filesystems internally, when 
> you consider logical block remapping etc.
> 
> And the claim by drive research guys at the filesystem/storage summit 
> was that OSD offered the potential to better optimize storage based on 
> access/usage patterns.
> 
> (of course, whether or not reality bears out this guess is another question)

That's true for multi-user access where knowing the context for each I/O
request - i.e. the object that holds it provides a crucial hint for
read-ahead and write allocation, where for a dumb device that doesn't
know anything about the filesystem's internals, it's much harder to
associate different blocks with their respective containers, or "streams"
(in case the container is typically accessed in a sequential pattern).

> 
> 
>> I can understand representing a single object as a block device (although I
>> think that using a file for that should be good enough and easier) but
>> why representing the whole OSD as a block device?  The OSD holds partitions
>> and objects each with attributes and OSD security related support.  Hence
>> representing that in a namespace using a filesystem seems straight forward.
> 
> I am actually considering writing a simple "osdblk" driver, that would 
> represent a single object as a block device.
> 
> This would NOT replace exofs or other OSD filesystems, but it would be 
> nice to have, and it will give me more experience with OSDs.

That's awesome!
It be really interesting to benchmark one against the other.

Benny

> 
> 	Jeff
> 
> 
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev

