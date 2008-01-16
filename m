Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYAPQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYAPQsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYAPQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:48:09 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49136 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbYAPQsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:48:08 -0500
Date: Wed, 16 Jan 2008 08:48:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Johannes Weiner <hannes@saeurebad.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <87lk6pvii0.fsf@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0801160831490.8188@schroedinger.engr.sgi.com>
References: <87lk6pvii0.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008, Johannes Weiner wrote:

> is there any reason why kfree() takes a const pointer just to degrade it
> with the call to slab_free()/__cache_free() again?  The promise that the
> pointee is not modified is just bogus in this case, anyway, isn't it?

The object is modified in various cases f.e. because of poisoning or the 
need to store the free pointer. So its bogus, yes. Pekka?


