Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYLJR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYLJR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLJR2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:28:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:26600 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYLJR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=irHxEIYlmAKWKRnN2pXTrfi0IcdwUG2Up/MkmxMrqpeXirtZ5Tjn+9xUryYY+Ydl4v
         TTTJdbn64Zf7Fptj0w5Ia4o+n08/Kr/a+54R3+/vV8gR5YZoZqnJSI2DyC1khuAhfsIk
         yuPXOaBLqC3BJCShVy9VNsNsicXx0SXfr0e+Y=
Message-ID: <8bd0f97a0812100928l2c75d373n7eba5aa0cc3882fd@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:28:33 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from platform_driver remove functions
Cc: dmitri.vorobiev@movial.fi, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 11:26, Julia Lawall wrote:
> The return value of the remove function of a driver structure, and thus of
> a platform_driver structure, is ultimately ignored, and is thus
> unnecessary.  The goal of this patch is to make it possible to convert the
> platform_driver functions stored in the remove field such that they return
> void.  This patch introduces a temporary field remove_new with return type
> void into the platform_driver structure, and updates the only place that
> the remove function is called to call the function in the remove_new field,
> if one is available.  The subsequent patches update some drivers to use the
> remove_new field.

why bother with remove -> remove_new convention ?  you'll get a
warning in C about the assignment, but you wont get a build failure,
nor should you get a runtime failure ... and if your ultimate goal is
to drop the return value, then this would be better as you'd get
warnings for everything that needs converting.  plus, once .remove is
gone, you're going to have to post another series of patches to
convert .remove_new back to .remove ...
-mike
