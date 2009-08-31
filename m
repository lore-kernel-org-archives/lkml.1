Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZHaMVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZHaMVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZHaMVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:21:30 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:57192 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZHaMV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=UnMCjm
	k2n7W1fBBChhLHn/FlQANyDB2Z5pna7EFFApNs8x3a+8e0XfD5qhx3TXeX0qY7K7
	iefhsf7ZqKPA1MDI6XgOp7rnYK1TbPI/31ZABb07b8xvy4ZBedRZlWFbo4wSS01u
	K2KxWM70UbQyd/1XyJhuSQK8jHtbEQ+113GpQ=
Message-ID: <4A9BC033.9000909@pobox.com>
Date: Mon, 31 Aug 2009 08:21:07 -0400
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: MD/RAID time out writing superblock
References: <004e01ca25e4$c11a54e0$434efea0$@ca>
 <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>
 <4A948A82.4080901@redhat.com>
 <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name>
 <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca>
 <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca>
 <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost>
 <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost>
 <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
In-Reply-To: <4A9B8583.9050601@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: CBE2E63A-9628-11DE-B171-CA0F1FFB4A78-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Ric Wheeler wrote:
..
>> The drive might take a longer time like this when doing error handling
>> (sector remapping, etc), but then I would expect to see your remapped
>> sector count grow.
> 
> Yes, this is a possibility and according to the spec, libata EH should
> be retrying flushes a few times before giving up but I'm not sure
> whether keeping retrying for several minutes is a good idea either.
> Is it?
..

Libata will retry only when the FLUSH returns an error,
and the next FLUSH will continue after the point where
the first attempt failed.

But if the drive can still auto-relocate sectors, then the
first FLUSH won't actually fail.. it will simply take longer
than normal.

A couple of those, and we're into the tens of seconds range
for time.

Still, it would be good to actually produce an error like that
to examine under controlled circumstances.

Hmm.. I had a drive here that gave symptoms like that.
Eventually, I discovered that drive had run out of relocatable
sectors, too.  Mmm.. I'll see if I can get it back (loaned it out)
and perhaps we can recreate this specific scenario on it..

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
