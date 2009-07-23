Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZGWCqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZGWCqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZGWCqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:46:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZGWCqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:46:35 -0400
Message-ID: <4A67CEB7.2080505@zytor.com>
Date: Wed, 22 Jul 2009 19:45:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.1) Gecko/20090715 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Subject: Re: [RFCv2][PATCH] flexible array implementation
References: <20090721220017.60A219D3@kernel>
In-Reply-To: <20090721220017.60A219D3@kernel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 03:00 PM, Dave Hansen wrote:
> 
> Here's an alternative.  I think it's what Andrew was
> suggesting  here:
> 
> 	http://lkml.org/lkml/2009/7/2/518 
> 
> I call it a flexible array.  It does all of its work in
> PAGE_SIZE bits, so never does an order>0 allocation.
> The base level has PAGE_SIZE-2*sizeof(int) bytes of
> storage for pointers to the second level.  So, with a
> 32-bit arch, you get about 4MB (4183112 bytes) of total
> storage when the objects pack nicely into a page.  It
> is half that on 64-bit because the pointers are twice
> the size.
> 

I'm wondering if there is any use case which would require scaling below
the PAGE_SIZE level... in which case it would be nice for it to
gracefully decay to a single kmalloc allocation + some metadata.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

