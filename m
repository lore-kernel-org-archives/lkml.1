Return-Path: <linux-kernel-owner+w=401wt.eu-S933618AbXHXSNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbXHXSNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbXHXSN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:13:29 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:17998 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760184AbXHXSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Op41/jSgv7LOejrMdMO2tihHvp75H0nI5oykMVIojBTyetQzwLalbHOj1tCXP+94UsOBETG1j/moAsLT3jqURnnwSQCAnmItRsdSDz6V6/Lwnh51QPMStIPy88IJv+Tx7pVJdBkRVz1y/pATtkWWXeiAAo4fXSth0kpDRZoBXyM=
Message-ID: <170fa0d20708241113y31d2ba95xf30c83c7c4c98cd2@mail.gmail.com>
Date: Fri, 24 Aug 2007 14:13:27 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: [PATCH 2/2] NBD: allow hung network I/O to be cancelled
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       david@dgreaves.com, "Wouter Verhelst" <w@uter.be>,
       "Corey Minyard" <cminyard@mvista.com>,
       nbd-general@lists.sourceforge.net
In-Reply-To: <46CF1826.9050101@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CF101F.4050603@steeleye.com> <46CF1826.9050101@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Paul Clements <paul.clements@steeleye.com> wrote:
> This patch allows NBD I/O to be cancelled when a network outage occurs.
> Previously, I/O would just hang, and if enough I/O was hung in nbd, the
> system (at least user-level) would completely hang until a TCP timeout
> (default, 15 minutes) occurred.
>
> The patch introduces a new ioctl NBD_SET_TIMEOUT that allows a transmit
> timeout value (in seconds) to be specified. Any network send that
> exceeds the timeout will be cancelled and the nbd connection will be
> shut down. I've tested with various timeout values and 6 seconds seems
> to be a good choice for the timeout. If the NBD_SET_TIMEOUT ioctl is not
> called, you get the old (I/O hang) behavior.

Hi Paul,

Thanks for implementing this!  Do you happen to have an associated
nbd-client patch for userspace?  If not I'd be happy to coordinate
with you and Wouter on a patch.

regards,
Mike
