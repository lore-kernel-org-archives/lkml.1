Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbYHOTPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbYHOTPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYHOTP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:15:28 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:52516 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756164AbYHOTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:15:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=TurBqDFGNfCA6pF1bMF5PFlqGLVL1dYljl3555PlW0iexTO6npUKlLPfOj3fVhdabqoX+h5ZiPoLL6Zd3THt/fYyKboklDAKq7+pShcgLx9TXfF1GC/UH3X0fqC8wMMi;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Fri, 15 Aug 2008 12:15:01 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
References: <for-27-patch1-0@bga.com> <200808151046.59590.jbarnes@virtuousgeek.org> <20080815205500.1945916f@hyperion.delvare>
In-Reply-To: <20080815205500.1945916f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808151215.02499.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 15, 2008 11:55 am Jean Delvare wrote:
> In fact we can do even better than that. We could accept from
> user-space only driver_data values which at least one device ID entry in
> the driver already uses. That should be fairly easy to implement, and
> would offer a level of safety an order of magnitude above what we have
> at the moment... And it works both ways: if 0 is not a valid data for
> some driver, that would force the user to provide a non-zero (and
> valid) data value. And it guarantees that the user can't ask for
> something the driver doesn't expect, so drivers don't even need extra
> checks. And no need for a use_driver_data flag either.

Meaning a driver audit of the usage?  Yeah that would be great.

> The only drawback is that it prevents the user from passing a "new"
> data value even if it would be valid. But honestly, I don't expect that
> case to happen frequently... if ever at all. So I'd say the benefits
> totally outweight the drawback.
>
> If the interested people agree with the idea, I'll look into
> implementing it.

Well the audit would show if user supplied "new" values are needed; otherwise 
the approach sounds good to me.

Thanks
-- 
Jesse Barnes, Intel Open Source Technology Center
