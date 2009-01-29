Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZA2DTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZA2DTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZA2DTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:19:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58284 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbZA2DS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:18:59 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Wed, 28 Jan 2009 22:18:42 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@bitplanet.net>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <200901281718.41873.jarod@redhat.com> <tkrat.8899c8be7878fd1f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8899c8be7878fd1f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282218.42604.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 18:11:32 Stefan Richter wrote:
> Jarod Wilson wrote:
> > On Saturday 24 January 2009 13:46:44 Stefan Richter wrote:
> >>   - Do 2nd and 3rd gen. iPods actually have a model_id == 0, or do they
> >>     have in fact no model_id at all?
> >
> > So far as I can decipher (using Kristian's csr-dump utility), they really
> > do have model_id == 0.
>
> If model_id weren't there, the older ieee1394/sbp2 driver would log
> model_id 0 (and match against quirks list entries with ID 0), while
> firewire-sbp2 logs model_id 0xff000000 (which is an impossible value and
> thus indicates to those who want to write a new quirks list entry that
> there is actually no model_id...).  I will soon push the patch which
> makes sbp2 behave like firewire-sbp2 in this regard, to eliminate a
> potential source of conflicting user reports.

Okay, so yeah, they definitely both have model_id == 0.

firewire_sbp2: Workarounds for fw2.0: 0x48 (firmware_revision 0x0a2700, 
model_id 0x000000).

On a related note... The fix capacity workaround... I think I need to
observe this failure myself... My own 4th-gen ipod, when connected to a
Mac OS X system, reports the exact capacity I get if the fix capacity
workaround is disabled. Do they just know not to try to access that
last block, or is the need for this workaround a myth? :)

-- 
Jarod Wilson
jarod@redhat.com

