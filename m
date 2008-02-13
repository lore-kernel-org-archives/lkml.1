Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYBMPpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYBMPpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYBMPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:44:36 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38067 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762834AbYBMPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:44:33 -0500
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>,
       Stefan Priebe - allied internet ag 
	<s.priebe@allied-internet.ag>
In-Reply-To: <47B1DA2A.1060904@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 09:44:28 -0600
Message-Id: <1202917468.3109.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
> -	gdth_flush(ha);
> -

This piece doesn't look right.  gdth_flush() forces the internal cache
to disk backing.  If you remove it, you're taking the chance that the
machine will be powered off without a writeback which can cause data
corruption.

James


