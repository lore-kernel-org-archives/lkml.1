Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYJATOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYJATOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJATOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:14:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:51534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYJATOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:14:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,344,1220252400"; 
   d="scan'208";a="622340288"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
       "kkeil@suse.de" <kkeil@suse.de>,
       "agospoda@redhat.com" <agospoda@redhat.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Graham, David" <david.graham@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "chris.jones@canonical.com" <chris.jones@canonical.com>,
       "tim.gardner@intel.com" <tim.gardner@intel.com>,
       "airlied@gmail.com" <airlied@gmail.com>, Olaf Kirch <okir@suse.cz>
Date: Wed, 1 Oct 2008 12:13:53 -0700
Subject: RE: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
Thread-Topic: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
Thread-Index: AckjydM2AHRM+RkKR0yrSLV3FhLFIwAFkl9A
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B16234BF4@orsmsx501.amr.corp.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
 <Pine.LNX.4.64.0809301439021.2307@twin.jikos.cz>
 <B27EBC40D200ED48A3F4CC2EBEABAE0B157C500E@orsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0810011528180.2307@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0810011528180.2307@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 01, 2008 6:29 AM, Jiri Kosina wrote:
>
>Olaf raised a rather interesting question -- would iAMT be
>able to access
>NVM contents directly, even if the lock bit would be set on the device?
>I.e. is iAMT allowed direct access to the EEPROM contents, bypassing
>shadow ram mappings?
>
>Thanks,
>
>--
>Jiri Kosina
>SUSE Labs
>

Only write/erase accesses are blocked by hardware after the protected range and lockdown bits are set in this patch; reads are still allowed.  I just received confirmation that iAMT does not write to the GbE region of the NVM.
