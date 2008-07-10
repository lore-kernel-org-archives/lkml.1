Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYGJNQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYGJNQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYGJNQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:16:45 -0400
Received: from swan.nt.tuwien.ac.at ([128.131.67.158]:46939 "EHLO
	swan.nt.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYGJNQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:16:45 -0400
Date: Thu, 10 Jul 2008 15:16:42 +0200
From: Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: IPSEC in 2.6.25 causes stalled connections
Message-ID: <20080710131642.GB22105@swan.nt.tuwien.ac.at>
References: <20080608010858.GA8877@swan.nt.tuwien.ac.at> <E1K8TuP-0002Qd-00@gondolin.me.apana.org.au> <20080618004544.GA25439@swan.nt.tuwien.ac.at> <20080708080742.GA25027@gondor.apana.org.au> <20080708213302.GA28842@swan.nt.tuwien.ac.at> <20080709084334.GA12484@gondor.apana.org.au> <20080710094345.GA24162@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710094345.GA24162@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 05:43:45PM +0800, Herbert Xu wrote:
> 
> OK, found it: chainiv never called the completion function!
> 
> commit 066068afee313b7746e7a3de05b57dcd4149a2fe
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu Jul 10 17:42:36 2008 +0800
> 
>     crypto: chainiv - Invoke completion function
>     
>     When chainiv postpones requests it never calls their completion functions.
>     This causes symptoms such as memory leaks when IPsec is in use.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Confirmed, your patch fixes the problem.

Thanks a lot!

Thomas
