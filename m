Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbZEQEah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbZEQEah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 00:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZEQEa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 00:30:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:54539 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZEQEa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 00:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P3x/RlkjhB2VNWBg+dyY22DWv8l+0Vh0DqlkKZ/C7KY80Lj6AGsQrkluK0rknvT9wz
         qbSnQH4VjXzM8aSeDfm+cQgEDoMvjMBJxSGPrrKki6CFoEcOs7iQE6F2tedw9/zlYMW7
         oECZDh+K765JL4TOBruQBV2gKKXo//vhzlBcM=
MIME-Version: 1.0
In-Reply-To: <20090517020829.GB6809@localhost>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
	 <alpine.DEB.1.10.0905151533070.13433@qirst.com>
	 <2c0942db0905160903i5517d3d6l50fc7457a2629694@mail.gmail.com>
	 <4A0EFA08.4060106@redhat.com> <20090517011906.GA6375@localhost>
	 <93655eb70905161827x34a432ebn4910ee86d9bae30@mail.gmail.com>
	 <20090517020829.GB6809@localhost>
Date: Sun, 17 May 2009 10:00:28 +0530
Message-ID: <93655eb70905162130k13ebd627o5eba2582508a1c07@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've prepared a rolled up patch for you, run time tested.  It should
> protect all of the above pages from being evicted by large file copies.
>
> The attached patch is for 2.6.29.

I applied the patch , but the number don seem to show much difference
, following are the statistics with the patched kernel, could
something else be causing the huge iowait,  :

Linux 2.6.29 (satish) 	05/17/2009

09:57:14 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
09:57:18 AM     all         12.93      0.00     10.25        33.44
 0.00     43.38
09:57:21 AM     all          13.32      0.00     28.09       24.40
 0.00     34.19
09:57:24 AM     all          10.79      0.00      4.76       75.56
 0.00      8.89
09:57:26 AM     all         11.46      0.00      8.01        35.64
 0.00     44.90
09:57:30 AM     all        11.68      0.00      8.88         35.05
 0.00     44.39
Average:           all         12.03      0.00     11.94      40.81
  0.00     35.22

and

hdparm -tT /dev/sda

/dev/sda:
 Timing cached reads:   1332 MB in  2.00 seconds = 666.35 MB/sec
 Timing buffered disk reads:   24 MB in  3.32 seconds =   7.23 MB/sec

,

Cheers
Satish
-- 
http://satish.playdrupal.com
