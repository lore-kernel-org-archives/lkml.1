Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZJ1RWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZJ1RWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZJ1RWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:22:24 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:24931 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753496AbZJ1RWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:22:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ig0p3yDfbkaS/8vAoWlgv3WO15xvJQ8WvgfBXBKzKbOZ/iB7rNONNvuZnPveMk2bEqMwJ1D9h7MCPIj4ZH9oJ3E3AmI61OTf73sKDBimzd0mfiZ+66rZnVey8ACJ0GqQqdv/6M2Z8AJBenIzJzIgezZeBPVg0nTEb0HZ64wz6Ag=;
Message-ID: <143841.81095.qm@web50110.mail.re2.yahoo.com>
X-YMail-OSG: afXWSgIVM1nZORgtoF7DdT8MlsCez9Eqjj03XDpefufDyBgnYafrfFoh5QzxRCsbUuLRvm3QRtAsco_kkg3QWkoNz24_KkFNYrgX2jjGkK3xwAHCWJ7CKlw.FUH.te_2.A9ixapGTKU9fgU5aY.qo9QDoyZfx3cczImZb5Re_oEXuSb9zsrTAFGrIeOcfLE_2yk7ijO9rnnS_Y45fBEA6Vezo9gn41vjwSd7XFU2Vn.rplbjgoPogE15O0i86iHZZl7Z3CFI9vv0W6LzHl5_Ntnd5UO4vW5u28bHHC0_gqQg03Lse5JG5ir6WQp472dgj7A31nxsqfeHmCLjJX52
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.361.4
Date: Wed, 28 Oct 2009 10:15:03 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC] amd64_edac: syndromes loading
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091028163534.GA625@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 10/28/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: [RFC] amd64_edac: syndromes loading
> To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "x86" <x86@kernel.org>
> Cc: "Doug Thompson" <norsk5@yahoo.com>, "LKML" <linux-kernel@vger.kernel.org>
> Date: Wednesday, October 28, 2009, 10:35 AM
> Hi,
> 
> I've been pondering how to avoid adding almost 15K of
> syndrome tables to
> the edac driver.
> 
> The syndrome tables are used for mapping a correctable ECC
> to the
> corresponding DIMM and thus pinpointing the DIMM about to
> fail. There
> are two flavors of syndromes based on the ECCs: x4 and x8.
> The x4 table
> of size 540 u16 values is already in the driver but the x8
> is much
> bigger (4864 u16) and I wouldn't want to add it statically
> into the
> driver.
> 
> Rather, I'd like to dynamically load them depending on the
> DRAM
> configuration of each node. The two attached patches do
> that using
> the request_firmware() interface. This way, the syndrome
> tables could
> be added as binary blobs in drivers/edac/ and then
> installed with
> 'make firmware_install'. This way we avoid polluting driver
> code with
> humongous u16 arrays of ECC syndromes.

Great idea. Load only when needed, based on hardware presence by triggered by probing, instead of an implicit always loaded.

Where does the syndrome table/module/firmware live in the file system? In with the amd64 module area or elsewhere?

doug t

> 
> What do you guys think, could that be an acceptable
> approach? Any
> suggestions/comments are welcome.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Operating | Advanced Micro Devices GmbH
>   System  | Karl-Hammerschmidt-Str. 34, 85609
> Dornach b. München, Germany
>  Research | Geschäftsführer: Andrew Bowd, Thomas M.
> McCoy, Giuliano Meroni
>   Center  | Sitz: Dornach, Gemeinde Aschheim,
> Landkreis München
>   (OSRC)  | Registergericht München, HRB Nr.
> 43632
> 
> 
