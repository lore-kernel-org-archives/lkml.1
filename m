Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZDPSJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZDPSJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 14:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbZDPSJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 14:09:11 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:43520 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755033AbZDPSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 14:09:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pi8QDIo1exWz6j46/kwEoKMG6iBJJcH0RLNl2QmNNWyNVb7u6ZomkHuvMMjszRuXvldT3/hQuyabBjz+2wN25MNleh2YaSPlW1bVA5egGXXxmLRB4X6sANeFQOJFp2qqB+QcR8WxtGmtxuPSybUeJtAAuL4gcJbSQ47rbKpHsKE=  ;
X-YMail-OSG: 9deCvtoVM1mkGd_EXbZ5_khhsqavaktp6nuAa7Jm1AUwdRmijU8xZvxXkilX9W3WA4QsDRZkxk4KcCU3yrhMuWhrK_3tkPTMExu6X91aaT7DNH_14BpSmwAjL53rdhg2zCC00IbRcqo7r8MGFTkRsZoMw6N9q_e5bMIC5LrtRcBglRGNvAE5DOCuZ9r8G9qKDsoSzySy5OlOW7weKlxlMkQkNz9xBioVphMPYiaWIkbo21QniGqT_zmBKGHk.Z.jqFSrcm6iEslWRRyh2IMPwlCUcwI26FzwelBvySZuUw3hhw4sKNcm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Fri, 17 Apr 2009 04:09:01 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904170409.02222.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 06:35:23 Linus Torvalds wrote:
> 
> On Wed, 15 Apr 2009, Chris Mason wrote:
> > 
> > Here is another version of the data=guarded work for ext3.  The main
> > difference between this code and yesterday's is the guarded writepage
> > function now sends any newly allocated block through the old data=ordered code.
> 
> I'm inclined to apply the first two patches as infrastructure, since they 
> seem to make sense regardless of data=ordered. The ability to get a 
> callback when IO ends sounds like something that a number of cases might 
> find intriguing, and it's obviously how the actual IO has worked 
> internally anyway.
> 
> Comments?

I think also fscache really should be using proper read completed notifications
rather than hijacking the page lock waitqueue for this.
