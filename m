Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYCNJ2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYCNJ2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYCNJ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:28:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYCNJ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:28:29 -0400
Message-ID: <47DA44EB.8000307@redhat.com>
Date: Fri, 14 Mar 2008 10:27:07 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com>
In-Reply-To: <20080309213441.GQ155407@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
>>> Also, the iolock can be held across I/O so it's possible you've lost an 
>>> I/O. Any I/O errors in the syslog?
>> No, no I/O errors at all. See the kern.log above, I could even do dd(1) 
>> from the md1 (dm-crypt on raid1), no errors either.
> 
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS. Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Yes, there is bug in dm-crypt...
Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71

Thanks,
Milan
--
mbroz@redhat.com

