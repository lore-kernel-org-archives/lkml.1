Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYF3EI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYF3EI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYF3EIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:08:18 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48486 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750777AbYF3EIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:08:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rZthfflQsTIXvnf5yhe9O5voANV/c+vjnU4jLPoFFyODwMlBztBG/N2eI0LPE6HMCOwfKHZ8atISSo4/RWpy5W+5D98JQJJ50tN67uoLueBqez7fIcI7vTY/nuCYekZ5eYaTAx88ys+5nchvNgxCXVYj4RQwr3+1Q0v4rgwmcc8=  ;
X-YMail-OSG: moVXucMVM1nft_TkUYZZVt104_2RIn5_299TdNAmoxR8X8znnK618nQD0MsBxMh524gehFZ8zY_gN4zhcepnm3xHrc1l2aYaqta3x317hZrRp0X.qnlHq8FuamQO_LL7NSI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] spi: split up spi_new_device() to allow two stage registration.
Date: Sun, 29 Jun 2008 21:08:15 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       jonsmirl@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <fa686aa40805232343x20031560j5659d203e25f494@mail.gmail.com> <fa686aa40805232354g147acfcdx4753fce1a448ceb7@mail.gmail.com>
In-Reply-To: <fa686aa40805232354g147acfcdx4753fce1a448ceb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806292108.15909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008, Grant Likely wrote:
> Question:  spi_alloc_device() (and the original code) does a
> spi_master_get() on the spi_master device.  Doesn't spi_master_put()
> need to be called when the device is discarded?  spi_dev_put() doesn't
> do that explicitly; is it an implicit operation after a device has
> been deregistered from the spi_master?

Depends whether or not the add() has been done to hook things into
the driver model tree, as I recall.  The add() presumes things are
properly refcounted.  When you make a driver model tree node vanish,
its associated refcounts get updated too.

- Dave

