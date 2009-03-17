Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZCQSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZCQSeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZCQSeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:34:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZCQSeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=duAfsh2mJFIAXzngliTzuvL3ptR6B1Q6zhIRpHtROexVPxMsYxjul8RIr62MNRFKWv
         vripv5UzwiP1IgHANFfpwEA/HubXSWTqoD6/iDRUPsFS+u6fePXCWr64Vz4CQHfiYLHx
         Yjr+5h5lWdxxxvC3AcvuiFCRYQbeD5gDoM0XQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903171355410.26058@qirst.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>
	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>
	 <alpine.DEB.1.10.0903171355410.26058@qirst.com>
Date: Tue, 17 Mar 2009 11:34:00 -0700
X-Google-Sender-Auth: 84266a4329cb21f2
Message-ID: <84144f020903171134q2283d01aq21a2faaa77ab07c6@mail.gmail.com>
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Nitin Gupta wrote:
>> Creating slabs for sizes in range, say, [32, 3/4*PAGE_SIZE] separated by
>> 64bytes
>> will require 48 slabs! Then for slab of each size class will have wastage
>> due to
>> unused slab objects in each class.
>> Larger difference in slab sizes (and thus small no. of them), will surely
>> cause too much
>> wastage due to internal fragmentation.

On Tue, Mar 17, 2009 at 10:58 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> The slabs that match existing other slabs of similar sizes will be aliased
> and not created. Create the 48 slabs and you likely will only use 10 real
> additional ones. The rest will just be pointing to existing ones.

Yup. One thing I don't quite understand is why you need all the 48
caches in the first place. Allocation sizes tend to be clustered and I
would have imagined you'd see that when compressing page sized chunks
as well. Using kmemtrace to analyze the exact reason for the bad
fragmentation would probably be helpful.
