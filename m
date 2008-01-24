Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYAXNOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYAXNOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYAXNO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:14:28 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYAXNO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:14:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=dp/9paBdaDgXmv+xuZda3zUal2gID9uBp4nCCOsPAZ+kg22HbzGWAfrwUxtI/Evay
	pw+UGxXipLsCztu3VGqWg==
Message-ID: <d9885f0f0801240514u76d8922bn1a2cdd5a75ad6639@mail.gmail.com>
Date: Thu, 24 Jan 2008 08:14:21 -0500
From: "Abhishek Rai" <abhishekrai@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm patch]
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rohitseth@google.com
In-Reply-To: <20080123234905.35664ed6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801230412.16992.abhishekrai@google.com>
	 <20080123234905.35664ed6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it didn't. I measured read from a 10GB sequentially laid out file
with standard benchmarking practices (cold cache, multiple runs, low
std. deviation in results, etc.) and here are the results:

File created by vanilla Ext3 being read by vanilla Ext3:
Total: 3m16.1s
User: 0.0.5s
Sys: 13.9

File created by mc Ext3 being read by mc Ext3 (with the buffer
boundary logic disabled):
Total: 3m15.5s
User: 0.05s
Sys: 13.6s

Thanks,
Abhishek

On Jan 24, 2008 2:49 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 23 Jan 2008 04:12:16 -0500 Abhishek Rai <abhishekrai@google.com> wrote:
> > > I'm wondering about the interaction between this code and the
> > > buffer_boundary() logic.  I guess we should disable the buffer_boundary()
> > > handling when this code is in effect.  Have you reviewed and tested that
> > > aspect?
> >
> > Thanks for pointing this out, I had totally missed this issue in my change. I've now made the call to set_buffer_boundary() in ext3_get_blocks_handle() subject to metacluster option being set.
> >
>
> Did it make any performance difference?  iirc the buffer_boundary stuff was
> worth around 10% on a single linear read of a large, well-laid-out file.
>
