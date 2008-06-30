Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbYF3T7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbYF3T7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763147AbYF3T7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:59:04 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:45025 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762763AbYF3T7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:59:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=pV2kOmWv0rnVZdFqXQCJwcrefAsypFVjfwJs2ZKOajs9hTfRiEfOvAZkKGkNCMekxUcKzTK2HJOotkt5EgoM3vwJ9h/IPueOlFb3uhfVkDWVALS6+jSsqs22XIMxjRy1YxkN8jcftgGqr6szzPUThaELY20XF5hJ+mzyB175atI=;
X-YMail-OSG: 3f9UrpAVM1nhASsfIYHK1_D0.JnAYV_VZBpwTf_Y4Ie.I04iH4YphKFl6xHrgCtZ.HCkyO9kjPzeMo2JQbqEdb66l6xJF.bNUSxaqLL9Jk3ccQNITZkD9FJkx81sHKhFw3gtLdwoWNA7uGNNB1QEYWk-
Date: Mon, 30 Jun 2008 12:58:59 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
To: Arthur Jones <ajones@riverbed.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080630150346.GF10571@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <262167.11235.qm@web50105.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Arthur Jones <ajones@riverbed.com> wrote:

> > Arthur, could you add some more text to the driver's output, before the call to the
> > core's output function, doing exactly that? Explaining just what you DO know, and what you
> don't
> > know?
> 
> Everything should be good except the DIMM label.  There
> are all kinds of ways this could be wrong (mainboard labelling,
> mainboard routing, ...).  I think it might be better just
> to leave this blank.
> 
> Are there any EDAC drivers that properly report the DIMM label?

The drivers don't print the information just because of these issues. The labeling action is left
to user space via edac-utils.  The label attributes in sysfs are initialized via a bootup daemon.
Thereby EDAC (and the driver) provides a mechanism of storing the DIMM Label. (The driver is free
to populate label if it so chooses, but that too could be overridden by userspace).

One driver I did for the Sicortex MIPS cluster only had TWO DIMMS, "East" and "West" on a 6 core
processor card. The driver labeled those inside itself.

> 
> How do they get around these issues?

Late binding. Allow the setting of the label by userspace. edac-utils utilizes a file database of
motherboards, which must be maintained yes, but it is flexible. An additional userspace program
could source the labels via another mechanism.

Lawrence Livermore National Labs has tens of thousands of nodes, with 2, 4 or 8 CPUs per node, and
they are the ones who developed the edac-utils userspace daemon and scripts. 

http://sourceforge.net/projects/edac-utils/

The model for EDAC modules IS to leave the DIMM label blank for late binding of that information.

> 
> Thanks...
> 
> Arthur


W1DUG
