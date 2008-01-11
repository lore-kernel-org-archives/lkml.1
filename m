Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYAKRFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYAKRFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbYAKRFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:05:31 -0500
Received: from phunq.net ([64.81.85.152]:53304 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758747AbYAKRFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:05:30 -0500
From: Daniel Phillips <phillips@phunq.net>
To: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Date: Fri, 11 Jan 2008 09:05:17 -0800
User-Agent: KMail/1.9.5
Cc: "Theodore Tso" <tytso@mit.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>,
       rohitseth@google.com
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <d9885f0f0712210615h661ad458x2cf4e4d0e8868772@mail.gmail.com> <d9885f0f0801101317n48e090d6x48f1792c71dc348e@mail.gmail.com>
In-Reply-To: <d9885f0f0801101317n48e090d6x48f1792c71dc348e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801110905.18464.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 13:17, Abhishek Rai wrote:
> Benchmark 5: fsck
> Description: Prepare a newly formated 400GB disk as follows: create
> 200 files of 0.5GB each, 100 files of 1GB each, 40 files of 2.5GB
> ech, and 10 files of 10GB each. fsck command line: fsck -f -n
> 1. vanilla:
>  Total: 11m25.3s
>  User: 13.4s
>  System: 13.2s
> 2. mc:
>  Total: 3m11.0s
>  User: 13.1s
>  System: 12.9s
>
> Note: I'll report results from kernbench and compilebench shortly.
>
> Observations:
> Sequential write performance is much better with metaclustering than
> with vanilla. To better understand it, I ran the same benchmark with
> the new code but with the metaclustering option turned off and I got
> the same performance as vanilla which makes me believe that there is
> something about metaclustering that helps write performance though I
> don't have a very good handle of what that thing might be.

Your results are very impressive.   In my opinion, the sooner this goes 
in, the better, since everybody hates waiting for fsck.  The only issue 
that jumps out at me is, the patch is big and changes a significant 
amount of Ext3 code outside of the metacluster path, which is not a bad 
thing except that these changes are going to need to be tested fairly 
heavily.

The way to do that is, put a big [CALL FOR TESTING] in your subject line 
the next time you post, and use an attention-getting subject line 
like "Make Ext3 fsck way faster".   Diff the patch against the latest 
stable kernel to make things as easy as possible for the people who are 
hopefully going to download your patch, try it, and report their 
results.

The other way is just to ask Andrew to put it in -mm when you feel 
ready, but your chances are much better if you already have people 
sending in mails saying how great your patch is.

Another thing you might consider is a port to Ext4.  After all, the 
world has waited this long for your patch, so it can likely survive 
waiting a little longer.

You somehow seem to have missed attracting the attention of Jon Corbet, 
a rare occurrence for a patch of this significance.  With the subject 
line modified as above, you are more likely to get the attention you 
deserve.  Good luck!

Regards,

Daniel
