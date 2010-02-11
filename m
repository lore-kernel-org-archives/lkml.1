Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0BKSGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:06:10 -0500
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:47972 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756610Ab0BKSGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:06:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=q4068oHeOBCH2mL/WQxcO+30QTeVpdvqVLsaLNVFP6M3Cnziye5Hujz8lQC3kTUPJYiqyEAYuJcT/kaLLzMhfkqSz44rC4tgsIVNY5HAZs+HDnrUP52yBBC43ybrCDVA34+YJoVNvq5RE9hFxrc7UqjUViOacEj1eqrcMbwslbI=;
Message-ID: <380256.20212.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: ChQKtfgVM1l2nojUhwMo3TpVpQ3pO35U..5tveeCwi9waTb58ID6LZ0K26GaGH.ErQw.txIXCQlcD9zmWAOSFuZZHVz6WYSgCeDSuK75N19YSJ3lrSE5w9yY3K07kcisQt93A3aIYnTGSpMfgQZhf0kp4.rQGJvhOZADFqUPo7.72gMNx6ME61Kj9ZuNIoYbPgEcZ4.qIwxy5epINde._Bn8l1vIhkvoOubdf_Kq12dT9Kta8xgjLR7PAvJA916m9T1MLufWdALi.MBk5qdOHErakA_hXmreF1YtvAWqFQVUD.V310IjyRLAlviaGVcl0jmvj.dwLk13qc2uCF8jtmIZ60g-
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Thu, 11 Feb 2010 10:06:07 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: Fw: [Bug 15238] Oops on startup: Kernel failure: EDAC amd64: WARNING: ECC is disabled by BIOS
To: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org,
       edac-devel <bluesmoke-devel@lists.sourceforge.net>
In-Reply-To: <20100211143443.GB32589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 2/11/10, Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <bp@amd64.org>
> Subject: Re: Fw: [Bug 15238] Oops on startup: Kernel failure: EDAC amd64: WARNING: ECC is disabled by BIOS
> To: "Doug Thompson" <norsk5@yahoo.com>, "Andrew Morton" <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org, "edac-devel" <bluesmoke-devel@lists.sourceforge.net>
> Date: Thursday, February 11, 2010, 7:34 AM
> Hi,
> 
> On Wed, Feb 10, 2010 at 09:53:03AM -0800, Doug Thompson
> wrote:
> > boris, can you look at this as well.
> > 
> > I think changing WARNING to a NOTICE in the log output
> would stop the oops parsing code from thinking this an OOPS
> event, when it is not
> > 
> > doug t
> > 
> > 
> > --- On Mon, 2/8/10, bugzilla-daemon@bugzilla.kernel.org
> <bugzilla-daemon@bugzilla.kernel.org>
> wrote:
> > 
> > > From: bugzilla-daemon@bugzilla.kernel.org
> <bugzilla-daemon@bugzilla.kernel.org>
> > > Subject: [Bug 15238] Oops on startup: Kernel
> failure: EDAC amd64: WARNING: ECC is disabled by BIOS
> > > To: dougthompson@xmission.com
> > > Date: Monday, February 8, 2010, 2:42 PM
> > > http://bugzilla.kernel.org/show_bug.cgi?id=15238
> > > 
> > > 
> > > Andrew Morton <akpm@linux-foundation.org>
> > > changed:
> > > 
> > >            What 
> > >   |Removed           
> > >          |Added
> > >
> ----------------------------------------------------------------------------
> > >          AssignedTo|akpm@linux-foundation.org   |dougthompson@xmission.com
> > > 
> > > 
> > > 
> > > 
> > > --- Comment #1 from Andrew Morton <akpm@linux-foundation.org> 
> > > 2010-02-08 21:42:40 ---
> > > Doug, could you please take a look at this one?
> 
> How about something like the following? If everyone is ok
> with that
> I'll send it to Linus and stable later since it is trivial
> enough:
> 
> dmesg:
> 
> EDAC amd64: ECC disabled in the BIOS or no ECC capability,
> module will not load.
>  Either enable ECC checking or force module loading by
> setting 'ecc_enable_override'.
>  (Note that use of the override may cause unknown side
> effects.)
> 
> patch:

Signed-of-by: Doug Thompson <dougthompson@xmission.com>

> 
> diff --git a/drivers/edac/amd64_edac.c
> b/drivers/edac/amd64_edac.c
> index 000dc67..3391e67 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2658,10 +2658,11 @@ static void
> amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
>   * the memory system completely. A command line
> option allows to force-enable
>   * hardware ECC later in
> amd64_enable_ecc_error_reporting().
>   */
> -static const char *ecc_warning =
> -    "WARNING: ECC is disabled by BIOS.
> Module will NOT be loaded.\n"
> -    " Either Enable ECC in the BIOS, or set
> 'ecc_enable_override'.\n"
> -    " Also, use of the override can cause
> unknown side effects.\n";
> +static const char *ecc_msg =
> +    "ECC disabled in the BIOS or no ECC
> capability, module will not load.\n"
> +    " Either enable ECC checking or force
> module loading by setting "
> +    "'ecc_enable_override'.\n"
> +    " (Note that use of the override may
> cause unknown side effects.)\n";
>  
>  static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
>  {
> @@ -2673,7 +2674,7 @@ static int
> amd64_check_ecc_enabled(struct amd64_pvt *pvt)
>  
>      ecc_enabled = !!(value &
> K8_NBCFG_ECC_ENABLE);
>      if (!ecc_enabled)
> -       
> amd64_printk(KERN_WARNING, "This node reports that Memory
> ECC "
> +       
> amd64_printk(KERN_NOTICE, "This node reports that Memory ECC
> "
>             
>      "is currently disabled, set
> F3x%x[22] (%s).\n",
>             
>      K8_NBCFG,
> pci_name(pvt->misc_f3_ctl));
>      else
> @@ -2681,13 +2682,13 @@ static int
> amd64_check_ecc_enabled(struct amd64_pvt *pvt)
>  
>      nb_mce_en =
> amd64_nb_mce_bank_enabled_on_node(pvt->mc_node_id);
>      if (!nb_mce_en)
> -       
> amd64_printk(KERN_WARNING, "NB MCE bank disabled, set MSR "
> +       
> amd64_printk(KERN_NOTICE, "NB MCE bank disabled, set MSR "
>             
>      "0x%08x[4] on node %d to
> enable.\n",
>             
>      MSR_IA32_MCG_CTL,
> pvt->mc_node_id);
>  
>      if (!ecc_enabled || !nb_mce_en) {
>          if
> (!ecc_enable_override) {
> -           
> amd64_printk(KERN_WARNING, "%s", ecc_warning);
> +           
> amd64_printk(KERN_NOTICE, "%s", ecc_msg);
>             
> return -ENODEV;
>          }
>          ecc_enable_override
> = 0;
> --
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> --
> Advanced Micro Devices, Inc.
> Operating Systems Research Center
> 
