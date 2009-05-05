Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZEEK0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZEEK0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZEEKZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:25:54 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:33348
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753495AbZEEKZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:25:54 -0400
X-BigFish: VPS-27(z34a4jz1432R98dR1805M179dR936fJzz1202hzzz32i6bh6di15fn61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ62AT-02-UDH-01
Date: Tue, 5 May 2009 12:25:40 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and
	mask in a family-specific way
Message-ID: <20090505102540.GA16248@aftab>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-10-git-send-email-borislav.petkov@amd.com> <49FF6532.7040206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <49FF6532.7040206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 05 May 2009 10:25:43.0440 (UTC) FILETIME=[D8829100:01C9CD6B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 06:59:14PM -0300, Mauro Carvalho Chehab wrote:
> Borislav Petkov escreveu:
>> +	for (cs = 0; cs < CHIPSELECT_COUNT; cs++) {
>> +		reg = K8_DCSB0 + (cs * 4);
>> +		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
>> +						&pvt->dcsb0[cs]);
>> +		if (err != 0)
>> +			debugf0("%s() Reading K8_DCSB0[%d] failed\n",
>> +				__func__, cs);
>> +
>> +		debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
>> +			cs, pvt->dcsb0[cs], reg);
>>   
>
> Hmm... I suspect that there's a missing else before the debugf0(). If  
> you got an error while reading it, you shouldn't be showing the results. 
>> +
>> +		/* If DCT are NOT ganged, then read in DCT1's base */
>> +		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
>> +			reg = F10_DCSB1 + (cs * 4);
>> +			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
>> +							&pvt->dcsb1[cs]);
>> +			if (err != 0)
>> +				debugf0("%s() Reading F10_DCSB1[%d] failed\n",
>> +					__func__, cs);
>> +			debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
>> +				cs, pvt->dcsb1[cs], reg);
>>   
> The same issue here: if you got an error while reading it, you shouldn't  
> be showing the results. 

correct, thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

