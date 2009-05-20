Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZETEtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZETEtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 00:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbZETEtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 00:49:11 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:36486 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750784AbZETEtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 00:49:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dT6HZfmUByfb63fmYAWtqy2hODwQx/rQEdwISb1G+641nnUKTVurHYLIRwuYTtlYOcsBxTnj0Bnhxd3bu06DVnIe56eeHMLTxTCJZg9wbzyHrMkiJwpBiKC9N2e2aUx9o4/xMasLZoAFQBDOdwKWkOS+zVXKjAOeJF5sjotxymU=  ;
X-YMail-OSG: lI9da5cVM1lDEtOqt0IthsuOMxX6Bj3rMUVv32n1HbdAUdoxxU1heiej5kHdLAv3vlrsuCly_VRrcMN1ASiVkjMXSzOu9dwxkOBRme.oGwSq_Pp1QSxzYjDAEsuGa8uDFN_x66FvwA9ZYff_I5Bv53dt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Tue, 19 May 2009 21:49:07 -0700
User-Agent: KMail/1.9.10
Cc: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905141324.27908.wolfgang.mues@auerswald.de> <20090519112948.GB28564@console-pimps.org>
In-Reply-To: <20090519112948.GB28564@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192149.07778.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009, Matt Fleming wrote:
> Hmm, always returning -EILSEQ is devious. What happens if we sent an
> illegal command? The value of "value" is passed up to the callers via
> cmd->error and so may eventually get printed in the pr_debug() call in
> mmc_request_done(), line 86.

True, but a pr_debug from mmc_spi could help that.  A patch doing
that would need to be less aggressive about ripping out the current
fault-parsing logic, but it could continue reporting -EILSEQ to
cope with the possible response mangling.


> Whereas before the error would display EINVAL for an illegal command
> now it'll display EILSEQ, which makes no sense. Seeing EILSEQ in my
> log when really the error is EINVAL is gonna really confuse me.
> 
> IMHO always assuming that command errors are caused by transmission
> problems is not the right solution.

Do you have a better solution to propose though?  If Wolfgang
is actually observing transmission errors there, I'm not sure
a better one is to be had.

Though I wonder what this would do for anyone trying SDIO over
the mmc_spi driver.

- Dave

