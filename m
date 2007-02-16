Return-Path: <linux-kernel-owner+w=401wt.eu-S966231AbXBPIjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231AbXBPIjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966235AbXBPIjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:39:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:48410 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231AbXBPIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Vdb5WVB82ngvqQhIr435RGqKYLMlQBMSgO2G3DpjfletMoSFiw9L0lo1wpayTyue0+PKzxZujwpvkzghq8LuCGPYhaQk5dW/yF3IZmHk1Aog8tlUr11BgIXGxIcXnIkhhXEMZnWsA8QW1XM3EYkXoWgg2npCAk8SKy824ool8iM=
Message-ID: <84144f020702160039y11fb1f4dl7b77d4358cc189ee@mail.gmail.com>
Date: Fri, 16 Feb 2007 10:39:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
Cc: "Andi Kleen" <ak@muc.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, "Chris Wright" <chrisw@sous-sol.org>,
       "Zachary Amsden" <zach@vmware.com>
In-Reply-To: <20070216022531.047039320@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216022449.739760547@goop.org>
	 <20070216022531.047039320@goop.org>
X-Google-Sender-Auth: 0a4930275e78d3bf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Remove the ctor for the pgd cache.  There's no point in having the
> cache machinery do this via an indirect call when all pgd are freed in
> the one place anyway.

The reason we have slab constructors and destructors is to _avoid_
reinitializing every time we allocate an object. AFAICT your changing
the code now to do _more_ work than before, so is there some other
reason why you want to do this than avoiding an indirect call?
