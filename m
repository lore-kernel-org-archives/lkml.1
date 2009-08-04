Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbZHDWto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbZHDWto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933419AbZHDWtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:49:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:23871 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377AbZHDWtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:49:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,324,1246863600"; 
   d="scan'208";a="713927641"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090804084903.GV3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
	 <1248710775.9958.0.camel@johannes.local>
	 <20090728112102.GA3382@ics.muni.cz> <1249336021.30019.4304.camel@rc-desk>
	 <20090804084903.GV3382@ics.muni.cz>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 15:49:43 -0700
Message-Id: <1249426183.30019.4581.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On Tue, 2009-08-04 at 01:49 -0700, Lukas Hejtmanek wrote:
> On Mon, Aug 03, 2009 at 02:47:01PM -0700, reinette chatre wrote:
> > I tried this on a T61.
> > 
> > As you say, there are two "rfkill" related buttons on this platform, the
> > actual rfkill switch on the front and the Fn+F5 buttons. Trying these
> > out I saw the following (output annotated to be readable - index 0 is
> > bluetooth and index 1 is wifi). It looks to me like things are behaving
> > reasonably and I do not see that Fn+F5 changes wifi at all.
> 
> This is my case:
> # Bluetooth SW off, WIFI SW on
> ./rfkill event
> RFKILL event: idx 6 type 1 op 0 soft 0 hard 0
> RFKILL event: idx 12 type 2 op 0 soft 1 hard 0
> # Fn-F5 pressed
> RFKILL event: idx 6 type 1 op 2 soft 1 hard 0
> RFKILL event: idx 12 type 2 op 2 soft 0 hard 0
> RFKILL event: idx 14 type 2 op 0 soft 0 hard 0
> RFKILL event: idx 14 type 2 op 2 soft 0 hard 0
> # Fn-F5 pressed
> RFKILL event: idx 6 type 1 op 2 soft 0 hard 0
> RFKILL event: idx 12 type 2 op 2 soft 1 hard 0
> RFKILL event: idx 14 type 2 op 1 soft 0 hard 0
> 
> all this is when HW kill is on and it is unchanged all the time.
> 
> idx 6 is WIFI
> idx 12, 14 is Bluetooth. (12 tpacpi_bluetooth_sw, 14 is hci0)
> 

This is strange. My previous test results were based on recent
wireless-testing. I now retested with a fresh pull from Linus's repo
(2.6.31-rc5) and I see the same behavior with Fn+F5 not changing the
wifi radio status at all. I do not know why we would see different
behavior considering we have the same platform and running the same
kernel. I found one related option in the BIOS, but with that I was only
able to have wireless HW rfkill permanently enabled.

I am not sure about the original problem though. In your original report
you mention that you are unable to use wireless due to rfkill. From your
email it seems that you are able to toggle wifi rfkill state using the
Fn+F5 keys, so with that disabling rfkill you should be able to use your
wireless. Can you still not use wireless even when rfkill reports
"RFKILL event: idx 6 type 1 op X soft 0 hard 0" ?

Reinette


