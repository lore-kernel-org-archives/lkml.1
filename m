Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXFTFIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXFTFIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbXFTFI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:08:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756041AbXFTFI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:08:28 -0400
Date: Tue, 19 Jun 2007 22:08:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: linux-mm@kvack.org, wli@holomorphy.com, lee.schermerhorn@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: Some thoughts on memory policies
In-Reply-To: <20070620040131.GA29240@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0706192205410.18467@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706181257010.13154@schroedinger.engr.sgi.com>
 <20070620040131.GA29240@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Paul Mundt wrote:

> There's quite a bit of room for improving and extending the existing
> code, and those options should likely be exhausted first.

There is a confusing maze of special rules if one goes beyond the simple 
process address space case. There are no clean rules on how to combine 
memory policies. Refcounting / updating becomes a problem because policies 
are intended to be only updated from the process that set them up. Look at 
the gimmicks that Paul needed to do to update memory policies when a 
process is migrated and the vmas on the stack for shmem etc etc.

