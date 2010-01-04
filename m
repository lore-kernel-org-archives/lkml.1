Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502Ab0ADOoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0ADOoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 09:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482Ab0ADOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 09:43:59 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34664 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0ADOn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 09:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bebT+VZ6fCfARp1GCwU8dWFAHmxczaslicEhPWoP58n/JZEu2VNZkwOvnbtqe8OR5o
         PSUQrhjK0n/cRBMKce7qbgK3bCt6/eOx/rPTiaB+XYlVQWSOlulQntN9djC8Id0U651L
         i/1SwjbYIXJ6jyaLpgASr2WjRX0RkW1pUZPEI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001040921000.29475@p34.internal.lan>
References: <alpine.DEB.1.10.0812300700410.11356@p34.internal.lan>
	 <4964DB3E.6080908@intel.com>
	 <alpine.DEB.1.10.0901071142200.29147@p34.internal.lan>
	 <1231356111.6648.2.camel@maxim-laptop> <49937CDF.10307@frugalware.org>
	 <alpine.DEB.1.10.0902121236120.19381@p34.internal.lan>
	 <1820d69d1001040551k26cfd925q4ada6b226740ac30@mail.gmail.com>
	 <alpine.DEB.2.00.1001040851490.29475@p34.internal.lan>
	 <1820d69d1001040609j6c0b169w38694c33af3fa686@mail.gmail.com>
	 <alpine.DEB.2.00.1001040921000.29475@p34.internal.lan>
Date: Mon, 4 Jan 2010 15:43:55 +0100
Message-ID: <1820d69d1001040643h5e2f383bo7e077cbc2d2af554@mail.gmail.com>
Subject: Re: [lm-sensors] Status/support for Linux HECI from Intel? (for 
	temp/voltage monitoring)
From: Gabriel C <nix.or.die@googlemail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Gabriel C <crazy@frugalware.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Andriy Gapon <avg@icyb.net.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/4 Justin Piszcz <jpiszcz@lucidpixels.com>:
>
>
> On Mon, 4 Jan 2010, Gabriel C wrote:
>
>>>>
>>>> Today I'm out from hospital so I've decided to quick hack this tool
>>>> and make it work on Linux.
>>>>
>>>> Here the output from my DQ45CB mobo:
>>>>
>>>> crazy@thor:~/INTEL/QST/Li$ sudo ./heci-qst
>>>> CPU  Temp:      56.00   °C
>>>> MB   Temp:      31.14   °C
>>>> ICH  Temp:      67.37   °C
>>>> MCH  Temp:      66.00   °C
>>>> CPU  Fan:       1080    RPM
>>>> INL  Fan:       1202    RPM
>>>> OUTL Fan:       288     RPM
>>>> +12  Volts:     11.965  V
>>>> +5   Volts:     5.021   V
>>>> +3.3 Volts:     3.316   V
>>>> MCH  Vccp:      1.122   V
>>>> CPU1 Vccp:      1.125   V
>>>>
>>>> Justin I know is not based on released SDK of Intel but maybe you
>>>> still want to do some tests ?:)
>
> DMI Info:
>
> Handle 0x0004, DMI type 0, 24 bytes
> BIOS Information
>        Vendor: Intel Corp.
>        Version: MQ96510J.86A.1754.2008.1117.0002
>
> Handle 0x0006, DMI type 2, 20 bytes
> Base Board Information
>        Manufacturer: Intel Corporation
>        Product Name: DG965WH
>        Version: AAD41692-304
>
> Cool, first time I have ever seen this =)
>
> # ./heci-qst-linux CPU  Temp:      36.55   °C
> MB   Temp:      38.75   °C
> MCH  Temp:      33.89   °C
> 04:     64.90   °C
> 05:     46.25   °C
> CPU  Fan:       836     RPM
> INL  Fan:       1362    RPM
> OUTL Fan:       836     RPM
> AUX  Fan:       2600    RPM
> +12  Volts:     12.029  V
> +5   Volts:     4.949   V
> +3.3 Volts:     3.247   V
> MCH  Vccp:      1.260   V
> CPU1 Vccp:      1.180   V
>
> It appears to work.
>
> Thanks,

NP :)

Anyway It seems like ICH8* has some different output .. can't tell yet
without docs =)

Please open heci-qst-linux.c and find :


const char * const temp_names[THERM_SENSOR_COUNT] = {
...

Change to look like this :


const char * const temp_names[THERM_SENSOR_COUNT] = {
       "CPU  Temp",
       "MB1  Temp",
        NULL,
       "MB2  Temp",
       "ICH  Temp",
       "MCH  Temp",
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
};


Also can you post a lspci -nn please :)

>
> Justin.
>


Gabriel
