Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZHaMVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZHaMVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZHaMVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:21:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:39929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZHaMVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:21:47 -0400
Message-ID: <4A9BC023.10903@kernel.org>
Date: Mon, 31 Aug 2009 21:20:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <004e01ca25e4$c11a54e0$434efea0$@ca>    <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name>    <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com>
In-Reply-To: <4A9BBC4A.6070708@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 12:20:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
>>> The drive might take a longer time like this when doing error handling
>>> (sector remapping, etc), but then I would expect to see your remapped
>>> sector count grow.
>>>      
>> Yes, this is a possibility and according to the spec, libata EH should
>> be retrying flushes a few times before giving up but I'm not sure
>> whether keeping retrying for several minutes is a good idea either.
>> Is it?
> 
> I don't think that retrying for minutes is a good idea. I wonder if this
> could be caused by power issues or cable issues to the drive?

IIRC, there were two identified weird reasons for flush timeouts.  The
first was quirky firmware which meant that using NCQ meant timeouts on
FLUSH.  The second was flaky power.  So, yeah, it can be caused by
power issue.  Not so sure about cable tho.

Thanks.

-- 
tejun
