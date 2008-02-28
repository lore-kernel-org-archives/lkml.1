Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYB1Bxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYB1Bxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYB1BxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:53:24 -0500
Received: from namei.org ([69.55.235.186]:49351 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755234AbYB1BxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:53:23 -0500
Date: Thu, 28 Feb 2008 12:52:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/11] NFSv4: Add label recommended attribute and NFSv4
 flags
In-Reply-To: <1204150294-4678-6-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0802281247130.27221@us.intercode.com.au>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1204150294-4678-6-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, David P. Quigley wrote:

> +#define NFS4_MAXLABELLEN	255

I remember raising this before, but I think we need to try and find a 
better way to implement this than always allocating labels of a fixed and 
possibly too-small size.

What about perhaps starting with a statically allocated array of say 64 
bytes (I can't see any labels on my system larger than that), and then 
falling back to a a dynamic allocation of up to 32k if it turns out to be 
too small ?  i.e. large labels are a slow path and there is no practical 
limit on label size.


- James
-- 
James Morris
<jmorris@namei.org>
