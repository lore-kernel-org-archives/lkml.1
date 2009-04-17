Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZDQVm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZDQVm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZDQVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:42:50 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:45733 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751051AbZDQVmu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:42:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UggoBbiCMzy/6YfpJmmJWgInjKlhNVoW+886/h6OTZFyg2qA+A/5/oEYDeB6vWMxFtZdBPptrEwv4GOFmCthJ8z9wFX9EIvaBwvy1MpqUmOaT75u9Kr+K68899E9ZZGrCr2JWJlRPX9dRw9eN/4nITfEPCqbhU7vdGECjlPPYLw=;
Message-ID: <406152.8763.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: IAWHyC4VM1nFk1Px7smy9BB3Ucp_Y.xP8e9Hd.DhFv5KSiSPZQOEDTnZkbJCLmybN2pcAL5nScY4r52HKSH9LqT7Um.AqnI4Qq7CigSIDHbXs4c4UeT5w3eZ_lri_Ebq9IoT1i.CVq.Eh7zJICdHxXVonK8MOqf7cT6e._CUuhAOSF_Yg_3rv352azHSB8tKBKys_t4_QAgxxfL0nrgVGfvMQCT8BUpOhKm64SqLmSqS3oLH8OrfKHoKr06GhvLJls6m0kDb8kU2OgU9xsJQ6wbFhkVc7_9vQdeHF6.XUpBEW4TQ8b_ma6H07GawOGUsucgQpog-
X-Mailer: YahooMailClassic/5.2.18 YahooMailWebService/0.7.289.10
Date: Fri, 17 Apr 2009 14:42:47 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [v2 PATCH 2/3] EDAC: Add edac_device_alloc_index()
To: Harry Ciao <qingtao.cao@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: michael@ellerman.id.au, bluesmoke-devel@lists.sourceforge.net,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 4/15/09, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [v2 PATCH 2/3] EDAC: Add edac_device_alloc_index()
> To: "Harry Ciao" <qingtao.cao@windriver.com>
> Cc: norsk5@yahoo.com, michael@ellerman.id.au, bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
> Date: Wednesday, April 15, 2009, 4:27 PM
> On Mon, 13 Apr 2009 14:05:15 +0800
> Harry Ciao <qingtao.cao@windriver.com>
> wrote:
> 
> > Add edac_device_alloc_index(), because for MAPLE
> platform there may
> > exist several EDAC driver modules that could make use
> of
> > edac_device_ctl_info structure at the same time. The
> index allocation
> > for these structures should be taken care of by EDAC
> core.
> > 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> keep things neat.  Also avoids having global
> identifier device_index
> shadowed by local identifier device_index.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Doug Thompson <dougthompson@xmission.com>

> Cc: Harry Ciao <qingtao.cao@windriver.com>
> Cc: Kumar Gala <galak@gate.crashing.org>
> Cc: Michael Ellerman <michael@ellerman.id.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/edac/edac_device.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN
> drivers/edac/amd8111_edac.c~edac-add-edac_device_alloc_index-cleanup
> drivers/edac/amd8111_edac.c
> diff -puN
> drivers/edac/edac_core.h~edac-add-edac_device_alloc_index-cleanup
> drivers/edac/edac_core.h
> diff -puN
> drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup
> drivers/edac/edac_device.c
> ---
> a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup
> +++ a/drivers/edac/edac_device.c
> @@ -37,7 +37,6 @@
>   */
>  static DEFINE_MUTEX(device_ctls_mutex);
>  static LIST_HEAD(edac_device_list);
> -static atomic_t device_indexes = ATOMIC_INIT(0);
>  
>  #ifdef CONFIG_EDAC_DEBUG
>  static void edac_device_dump_device(struct
> edac_device_ctl_info *edac_dev)
> @@ -499,6 +498,8 @@ void
> edac_device_reset_delay_period(stru
>   */
>  int edac_device_alloc_index(void)
>  {
> +    static atomic_t device_indexes =
> ATOMIC_INIT(0);
> +
>      return
> atomic_inc_return(&device_indexes) - 1;
>  }
>  EXPORT_SYMBOL_GPL(edac_device_alloc_index);
> _
> 
> 
