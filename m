Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbXEFSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbXEFSXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXEFSXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:23:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:28410 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXEFSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YO7iydcqhtEe7pKvXpbyltnlOy3R0cvUHYnaBvxpy6Rj+1c8MpT1dWOk73w050S5G78Ks+ebHlYKwKuXDSE7M8vseMNU5C8oSPYaHemFqEUPhESw89WcqlXABv23XFzE6A8gLs1sVnOvtIzzWdIR7Had4Z2hCKdMJ/+HOTD1kyQ=
Message-ID: <463E1CE3.6010908@gmail.com>
Date: Sun, 06 May 2007 13:22:27 -0500
From: "Jory A. Pratt" <geekypenguin@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070422)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [ck] Re: swap-prefetch: 2.6.22 -mm merge plans
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	<20070504085201.GA24666@elte.hu>	<200705042210.15953.kernel@kolivas.org> <200705051842.32328.kernel@kolivas.org>
In-Reply-To: <200705051842.32328.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> Here's a better swap prefetch tester. Instructions in file.
>
> Machine with 2GB ram and 2GB swapfile
>
> Prefetch disabled:
> ./sp_tester
> Ram 2060352000  Swap 1973420000
> Total ram to be malloced: 3047062000 bytes
> Starting first malloc of 1523531000 bytes
> Starting 1st read of first malloc
> Touching this much ram takes 809 milliseconds
> Starting second malloc of 1523531000 bytes
> Completed second malloc and free
> Sleeping for 600 seconds
> Important part - starting reread of first malloc
> Completed read of first malloc
> Timed portion 53397 milliseconds
>
> Enabled:
> ./sp_tester
> Ram 2060352000  Swap 1973420000
> Total ram to be malloced: 3047062000 bytes
> Starting first malloc of 1523531000 bytes
> Starting 1st read of first malloc
> Touching this much ram takes 676 milliseconds
> Starting second malloc of 1523531000 bytes
> Completed second malloc and free
> Sleeping for 600 seconds
> Important part - starting reread of first malloc
> Completed read of first malloc
> Timed portion 26351 milliseconds
>   
echo 1 > /proc/sys/vm/overcommit_memory
swapoff -a
swapon -a
./sp_tester

Ram 1153644000  Swap 1004052000
Total ram to be malloced: 1655670000 bytes
Starting first malloc of 827835000 bytes
Starting 1st read of first malloc
Touching this much ram takes 937 milliseconds
Starting second malloc of 827835000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 15011 milliseconds

echo 0 > /proc/sys/vm/overcommit_memory
swapoff -a
swapon -a
./sp_tester

Ram 1153644000  Swap 1004052000
Total ram to be malloced: 1655670000 bytes
Starting first malloc of 827835000 bytes
Starting 1st read of first malloc
Touching this much ram takes 1125 milliseconds
Starting second malloc of 827835000 bytes
Completed second malloc and free
Sleeping for 600 seconds
Important part - starting reread of first malloc
Completed read of first malloc
Timed portion 14611 milliseconds

