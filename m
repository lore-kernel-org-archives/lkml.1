Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYIJM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYIJM5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYIJM5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:57:36 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15371 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526AbYIJM5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:57:35 -0400
Message-ID: <48C7C428.5090209@panasas.com>
Date: Wed, 10 Sep 2008 15:57:12 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] 24-bit types: typedef and functions for accessing 3-byte
 arrays as integers
References: <41b516cb0809071052t1aea47b3hd7dc40d3bb1cfce3@mail.gmail.com> <20080909225930.19495.64220.stgit@localhost.localdomain>
In-Reply-To: <20080909225930.19495.64220.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2008 12:56:20.0227 (UTC) FILETIME=[9EF41530:01C91344]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
> frame headers.  This patch defines __be24 and __le24 typedefs for a
> structure wrapped around a 3-byte array, and functions to convert back and
> forth to a 32-bit integer.
> 
> The undefs in iscsi_proto.h are because of the different calling
> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
> be converted in a subsequent patch.
> 
> Changes from last posting:
> 
> Switched from preprocessor macros to inline functions.  The generated assembly
> is the same with gcc 4.1.2 as long as the function is actually inlined.  I
> applied the __always_inline attribute to all of these, after seeing that with
> one of my test kernel configurations they were not being inlined without it
> and the generated instructions in the iSCSI code could be considered a
> regression from the existing macro.
> 
> Signed-off-by: Chris Leech <christopher.leech@intel.com>
> ---
> 
>  include/linux/byteorder.h         |   44 ++++++++++++++++++++++++++++++++++++
>  include/linux/byteorder/generic.h |   45 +++++++++++++++++++++++++++++++++++++
>  include/linux/types.h             |    2 ++
>  include/scsi/iscsi_proto.h        |    2 ++
>  4 files changed, 93 insertions(+), 0 deletions(-)
> 
<snip>

Thanks! Personally I like this much better.

Sorry to be nit picking but again I hate that double implementation thing.
>From what I could see, and considering a few of the ARCHs you mentioned,
it looks to me like <linux/swab.h> is common to the two implementations,
(old and new). Perhaps put the "__xxx" implementations in swab.h and
only the xxx => __xxx switching in the double byteorder headers, which
fits better with the surrounding style of these headers. 

Thanks
Boaz
