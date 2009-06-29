Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZF2Mpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZF2Mpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZF2MpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:45:18 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:5211
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751894AbZF2MpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:45:17 -0400
Message-ID: <4A48B75C.5080209@panasas.com>
Date: Mon, 29 Jun 2009 15:45:16 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: NeilBrown <neilb@suse.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
 of the 'queue' sysfs directory.
References: <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name> <20090626132940.GR23611@kernel.dk> <19014.4447.248248.63960@notabene.brown> <20090629101841.GF23611@kernel.dk> <b0aa07ac85efd6040501e4ea875176a3.squirrel@neil.brown.name> <20090629114121.GH23611@kernel.dk>
In-Reply-To: <20090629114121.GH23611@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 12:45:20.0350 (UTC) FILETIME=[7641D7E0:01C9F8B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 02:41 PM, Jens Axboe wrote:
> On Mon, Jun 29 2009, NeilBrown wrote:
>> On Mon, June 29, 2009 8:18 pm, Jens Axboe wrote:
>>> On Sat, Jun 27 2009, Neil Brown wrote:
>>>>> There's no such thing as first or second class block devices. The fact
>>>>> that drivers using ->make_request_fn directly do not utilize the full
>>>>> scope of the queue isn't a very interesting fact, imho.
>>>>  Your phrase "drivers using ->make_request_fn directly" seems to
>>>>  suggest you are looking at things very differently to me.
>>>>
>>>>  From my perspective, all drivers use ->make_request_fn equally.
>>>>  Some set it to "__make_request", some to "md_make_request", others to
>>>>  "dm_request" or "loop_make_request" etc.
>>> Neil, will you please stop these silly games. Stop trying to invent
>>> differences based on interpretations of what you read into my replies.
>>
>> We do seem to be having trouble communicating don't we :-(
>> Be assured that it is not my intention to play games, silly or otherwise.
>>
>> Maybe I should just try sending you patches.  Maybe that will
>> make my meaning clearer.
>>
>> For the moment, I'm much more interested in the other question,
>> that of whether I can avoid having a 'queue' directory introduced into
>> md/dm/etc device directories in sysfs.
> 
> We already talked about this, several times. My answer is that it seems
> pointless to begin with internally, and externally it just makes the API
> worse since tools then have to know which device type they are talking
> to.
> 

I do however see a problem with sysfs-files that mostly work for most devices
but for some "device type" they do nothing silently. At least make these
directory/files read-only for the un-used cases (eg. dm/md). And return proper
values to indicate their un-usefulness like "-1" or "NA"

> So I still see absolutely zero point in making such a change, quite the
> opposite.
> 

Just my $0.017
Boaz
