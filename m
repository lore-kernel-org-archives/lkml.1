Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXKWWDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXKWWDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 17:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXKWWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 17:02:54 -0500
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:42753 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbXKWWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 17:02:54 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [RFC] Documentation about unaligned memory access
Date: Fri, 23 Nov 2007 14:02:48 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711231402.48763.vlobanov@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007 04:15:53 pm Daniel Drake wrote:
> Fortunately things are not too complex, as in most cases, the compiler
> ensures that things will work for you. For example, take the following
> structure:
>
> 	struct foo {
> 		u16 field1;
> 		u32 field2;
> 		u8 field3;
> 	};
>
> Fortunately, the compiler understands the alignment constraints, so in the
> above case it would insert 2 bytes of padding inbetween field1 and field2.
> Therefore, for standard structure types you can always rely on the compiler
> to pad structures so that accesses to fields are suitably aligned (assuming
> you do not cast the field to a type of different length).

It would also insert 3 bytes of padding after field3, in order to satisfy 
alignment constraints for arrays of these structures.

> Sidenote: in the above example, you may wish to reorder the fields in the
> above structure so that the overall structure uses less memory. For
> example, moving field3 to sit inbetween field1 and field2 (where the
> padding is inserted) would shrink the overall structure by 1 byte:
>
> 	struct foo {
> 		u16 field1;
> 		u8 field3;
> 		u32 field2;
> 	};

It will actually shrink it by 4 bytes, for the very same reason.

-- Vadim Lobanov


