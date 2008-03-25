Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYCYOXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYCYOXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYCYOXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:23:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62985 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYCYOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FVkrghzfU/4IcZ3uHOKMkaSL7QNLZHs/TMzJbiu0H5CUo/B15urRL+1Co1JqxsayAbJTBBnt08YMgr2v134O1JdtcEsgozQhHRTEPHzNtEubA5mbOyH++7kzBZdgNKP2T0wPcm/dN93BasUj2skNHO9tr4Xsp5+WcnKt1/vzj84=
Message-ID: <e2e108260803250723k345a7387y117d9bcbcabf135c@mail.gmail.com>
Date: Tue, 25 Mar 2008 15:23:09 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Sanders, Rob M." <sanders-rob@zai.com>
Subject: Re: Performance changes between 2.6.13 and 2.6.23
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <D108F32273D3044F8C7B24328CB7713701A4D2@york.rivers.zai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com>
	 <e2e108260803250625k581909dcw3c3c0742a7b9fceb@mail.gmail.com>
	 <D108F32273D3044F8C7B24328CB7713701A4D2@york.rivers.zai.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 2:52 PM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
>   Each process is single threaded, although each process is built with the
>  -lpthread library.  For this particular application I would expect the
>  bottleneck to be in I/O (between processes) bound.  I hadn't thought
>  about trying to boot YDL4 using the new kernel, I'll try that, and I'll
>  look at the lmench2 and interbench.  Thanks....

In that case it might be interesting to observe the number of context
switches per second caused by the different processes. If the product
of the context switch time reported by lmbench2 and the number of
context switches per second is more than about 0.1, this means that a
lot of time is spent in just context switching and the application
probably should be optimized to cause less context switches. This
holds for any OS.

On a Linux system you can observe the number of context switches
performed by all processes e.g. via the following bash script:

interval=5; last=""; while true; do ctxt=$(while read col1 col2 rest;
do if [ $col1 = ctxt ]; then echo $col2; fi; done </proc/stat); if [
"$last" != "" ]; then echo $(((ctxt-last)/interval)); fi; last=$ctxt;
sleep $interval; done

The above script uses as much bash built-ins as possible such that it
causes as few context switches as possible.

Bart.
