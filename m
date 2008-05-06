Return-Path: <linux-kernel-owner+w=401wt.eu-S1764651AbYEFPx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764651AbYEFPx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbYEFPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:53:20 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:8984 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbYEFPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:53:19 -0400
Message-ID: <48207EEC.6050709@de.ibm.com>
Date: Tue, 06 May 2008 17:53:16 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: ltp-list@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       ltp-coverage@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths
 only
References: <481F26A0.5010402@de.ibm.com> <20080505195548.GC8868@uranus.ravnborg.org>
In-Reply-To: <20080505195548.GC8868@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, May 05, 2008 at 05:24:16PM +0200, Peter Oberparleiter wrote:
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> ===================================================================
>> --- linux-2.6.26-rc1.orig/scripts/Kbuild.include
>> +++ linux-2.6.26-rc1/scripts/Kbuild.include
>> @@ -144,7 +144,7 @@ ld-option = $(call try-run,\
>>  build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
>>  
>>  # Prefix -I with $(srctree) if it is not an absolute path.
>> -addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
>> +addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
>>  
>>  # Find all -I options and call addtree
>>  flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))
> 
> We try to make all paths relative so less files get rebuild if you access the
> same source from two different paths (think nfs mounted src etc).
> So you really need to justify this change.

I understand your point about keeping as many paths as possible relative
and would like to discuss that in the reply to patch 3, where most
changes towards absolute paths are done.

As for this patch: on second thought I think this change makes no sense
without the next patch - I'll have to redo them both.


Regards,
  Peter
