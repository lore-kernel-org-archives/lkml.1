Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYIHTZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYIHTZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYIHTZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:25:32 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42402 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753208AbYIHTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:25:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ndcb3upaskeu/UxVfbPj00C6LZloseB8ozVW6tKPFVCxrYPqAWzBZd3APZ9pjmuvPh55Fv/ti4keP6i9ZlzgWeGA8hWrYsh0pAvonp5vp9cLxAWjXNYTrRhwUcD6y6nUyUHNQ/VAknV2z96jxLNhEpwmjGhCWHFZ259Sjez/XOI=  ;
X-YMail-OSG: ea2i7JAVM1l832znWxXTm3Lm2TrBA7zPaD8rbndYzGQJd3yfjVTHqlXqJZHUuDa1X.6stthy4_FAbBIu5QW2goc7EEMq6eGfWoCf7oWD7D.g6UKEBn11_nTnTsoRykk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Date: Mon, 8 Sep 2008 12:18:49 -0700
User-Agent: KMail/1.9.9
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com> <20080907123832.5ba79c12@mjolnir.drzeus.cx> <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
In-Reply-To: <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081218.49766.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, Matt Fleming wrote:
> Currently, the MMC/SD over SPI code has a hard-coded timeout value of
> 250ms on writes and 100ms on reads. This is correct for SDHC cards
> and is specified in the spec, but it is not correct for MMC/SD cards.
> 
> For MMC cards the values that are read from the CSR should be used.
> For SD cards the values from the CSR should be used as long as they
> do not exceed 250ms for writes and 100ms for reads.
> 
> Signed-off-by: Matthew Fleming <matthew.fleming@imgtec.com>

OK by me.  I was viewing those values as ceilings, such that
waiting too long wouldn't much matter.  If there are cases
where the CSR values are larger, they clearly should trump.

