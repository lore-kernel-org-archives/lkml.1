Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYHUS3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYHUS3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYHUS3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:29:31 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:20658 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753207AbYHUS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:29:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RqIbheGASmcvmg8qkvo72fZOZJJjMZHuwUCnokz15HdcqeeKjEQZS35OH/cM/0HGgpN0NMQ9wrI5uhcRUwna35fl3zc6HJRzXgIgNWjKUVusShyDM/Fmh4tmksE0atrhaPypfJK+pAzObRuWbNAKnom5dYCbdht2ylXT/XhU0q8=  ;
X-YMail-OSG: 9isq0uwVM1nOSwZGQ5Jr7GbLpnJtey_pDua69mi_glbNkEjK2TCz4ZwgKzG1oM3xETudrgGajTprw0EkDmB4cchpN06OcRUSitpQsXapKw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 06/15] driver model: anti-oopsing medicine
Date: Thu, 21 Aug 2008 11:24:22 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080821173036.GB7974@suse.de> <1219339983-9634-6-git-send-email-gregkh@suse.de>
In-Reply-To: <1219339983-9634-6-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808211124.22485.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Greg Kroah-Hartman wrote:
> +       if (!class->p) {
> +               WARN(1, "%s called for class '%s' before it was initialized",
> +                    __func__, class->name);
> +               return -EINVAL;
> +       }

Or -- for future reference -- using WARN() with non-constant
initial parameter:

	if (WARN(!class-p, "%s called ...\n" ...))
		return -EINVAL;

Some of those macros now have return values, supportin C code
that looks a bit more compact.

- Dave
