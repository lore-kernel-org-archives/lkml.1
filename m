Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYFEQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYFEQPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYFEQPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:15:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYFEQPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:15:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RqJQ/bihfkEtJt/uuTjK5803h6NRjf2JhJW5+nLyBPeAxCVhmpS7RMMG3SeyvxDOx
	BXL4RCoi0sd8o94oNYn4A==
Message-ID: <4ca0a85e0806050914v5dc78fbcv373b08f09e37a337@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:14:43 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in multiples of 8
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1212682175.3953.169.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
	 <1212681822.3953.162.camel@calx>
	 <4ca0a85e0806050905j6cf33f3dx9143333aa0a8b6e7@mail.gmail.com>
	 <1212682175.3953.169.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 12:09 PM, Matt Mackall <mpm@selenic.com> wrote:
> Yes, I got that, I'm just mathematically impaired this morning. Read
> that as "when someone tries to do a *20* byte read, do a 16-byte read.."
> In other words, round down to the nearest multiple of 8.

Oh.  I would seriously question doing that, because it would allow
reads that are improperly split up to fail silently.  What happens if
someone tries to read 40 bytes, and (for some reason) it gets split
into two 20-byte reads?  Instead of "12345" they'll get "12.34."
(where . is 4 zero or garbage bytes).  I'd rather they get an error.

--ttuttle
