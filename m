Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYJVUtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYJVUtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJVUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:48:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:22043 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYJVUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gJf4MSu3xC8FzRPXgnbFF4wxXbz9tRFUiXeM/mjIJTUX5nRECg7krNamuBrFfHD1uq
         FM13yVp/sBrAkFSCO+LDxjSQy+70a8h3NBr1ficQY+TeoyJRqPqHYijB/+GQr2BLLnCm
         LUuIFAh4PDAw/8M4/Dj5Ji5/Uufi0mQTGpIFQ=
Message-ID: <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
Date: Wed, 22 Oct 2008 23:48:56 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: SLUB defrag pull request?
Cc: cl@linux-foundation.org, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223883004.31587.15.camel@penberg-laptop>
	 <E1Ks1hu-0002nN-9f@pomaz-ex.szeredi.hu>
	 <48FE6306.6020806@linux-foundation.org>
	 <E1KsXrY-0000AU-C4@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810220822500.30851@quilx.com>
	 <E1Ksjed-00023D-UB@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221252570.3562@quilx.com>
	 <E1Ksk3g-00027r-Lp@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221315080.26671@quilx.com>
	 <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: 6a83c5c8eccd3233
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Because you don't _need_ a reliable reference to access the contents
> of the dentry.  The dentry is still there after being freed, as long
> as the underlying slab is there and isn't being reused for some other
> purpose.  But you can easily ensure that from the slab code.
>
> Hmm?

Actually, when debugging is enabled, it's customary to poison the
object, for example (see free_debug_processing() in mm/slub.c). So we
really can't "easily ensure" that in the allocator unless we by-pass
all the current debugging code.
