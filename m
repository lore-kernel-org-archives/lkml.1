Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYGKIeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYGKIeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYGKIdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:33:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:36592 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbYGKIdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=bNv7BOGj/cY6NfNGfuv34mq5fD5lRxe5LG2GJ7kffU8PNWY6W3CvqQNFk5tGDa3QRI
         OAjwB40fWoO7C2sZam7+Mo34BrJQvGlacA+LfcE7zLsAzO+33nLDQlPN4jaYINVCS9iw
         z3/8IHPwq7Ps6XBNT/3uw092w4PpQjuN5scXk=
Message-ID: <84144f020807110133y693987e0mdeb8e90d87e46ea2@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:33:53 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [RFC PATCH 2/5] Add new GFP flag __GFP_NOTRACE.
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080710210606.65e240f4@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	 <20080710210606.65e240f4@linux360.ro>
X-Google-Sender-Auth: 86dd61d63b36a274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduard-Gabriel,

On Thu, Jul 10, 2008 at 9:06 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> __GFP_NOTRACE turns off allocator tracing for that particular allocation.
>
> This is used by kmemtrace to correctly classify different kinds of
> allocations, without recording one event multiple times. Example: SLAB's
> kmalloc() calls kmem_cache_alloc(), but we want to record this only as a
> kmalloc.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

I don't like this approach. I think you can just place the hooks in
the proper place in SLAB to avoid this?
