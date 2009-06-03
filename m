Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZFCR24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZFCR24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZFCR2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:28:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbZFCR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:28:49 -0400
Date: Wed, 3 Jun 2009 10:28:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@parisplace.org>
cc: Rik van Riel <riel@redhat.com>, "Larry H." <research@subreption.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <7e0fb38c0906031016m77416390v37fb0673e6e50501@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906031018550.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>  <20090531022158.GA9033@oblivion.subreption.com>  <alpine.DEB.1.10.0906021130410.23962@gentwo.org>  <20090602203405.GC6701@oblivion.subreption.com>  <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
  <1244041914.12272.64.camel@localhost.localdomain>  <alpine.DEB.1.10.0906031134410.13551@gentwo.org>  <20090603162831.GF6701@oblivion.subreption.com>  <4A26A689.1090300@redhat.com>  <alpine.LFD.2.01.0906030944440.4880@localhost.localdomain>
 <7e0fb38c0906031016m77416390v37fb0673e6e50501@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Eric Paris wrote:
> 
> I am at least interested in hearing about the 'performance plummet.'

It's perhaps not so much SElinux itself, but the AUDIT support (which it 
requires) that is really _very_ noticeable on microbenchmarks.

Last time I ran lmbench on a Fedora kernel it was horrible. Turning off 
AUDIT (which also turns off SElinux) fixes it.

It may be crazy distro auditing rules or whatever, but that doesn't change 
the basic issue. 

		Linus
