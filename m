Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYKRWBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYKRWBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYKRWA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:00:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:56649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYKRWA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=b0DTBL7//c25bS274OHfFUKMce14DS7rRdNMWo5nC30mejKM5lVAPe+eX2lIhL2FOl
         R85K071mUp0TPMc+TQFrR+/Ewvyd5sOl543i62saPP5lovYeQIXppaz7VAUq1LYAPjX+
         yuOgPU78GbZLsXTcmVUG5l9+MHJgREAsr26h8=
Message-ID: <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
Date: Tue, 18 Nov 2008 23:00:56 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: debugctl msr
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226743286.6162.6.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1226236327.6104.4.camel@raistlin>
	 <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

I think your definition for ds_cfg_64 is wrong. On Core, the PEBS
record ALWAYS includes r8-r15 even on
32 bits (zero filled). Also the DS_AREA has 9 fields, not 8.
Consequently, I think the structure should be defined
as follows:

static const struct ds_configuration ds_cfg_64 = {
        .sizeof_ds    = 8 * 9,
        .sizeof_field = 8,
        .sizeof_rec[ds_bts]   = 8 * 3,
        .sizeof_rec[ds_pebs]  = 8 * 18
};

Do you agree?

Thanks.
