Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbZDAPMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbZDAPMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762473AbZDAPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:12:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41333 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752AbZDAPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:12:30 -0400
Date: Wed, 1 Apr 2009 16:12:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Theodore Tso <tytso@mit.edu>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090401151219.GA12285@srcf.ucam.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401052050.GA20456@sucs.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 06:20:50AM +0100, Sitsofe Wheeler wrote:

> Just out of curiosity, when laptop mode is happening is there a
> guarantee that writes to other files won't be reordered to before the
> fsync? 

laptop-mode does two things - tweak the dirty page semantics slightly 
(not in an interestingly relevant way) and call sys_sync() a few seconds 
after something hits disk rather than cache. In contrast to Ted's 
suggestion that laptop-mode reduces data integrity, it actually enhances 
it by opportunistically ensuring that data hits disk. It's the 
lengthening of the commit intervals that usually accompanies it that 
increases the risk of data loss.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
