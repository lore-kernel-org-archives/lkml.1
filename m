Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0BSVxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:53:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:34016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0BSVxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:53:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,505,1262592000"; 
   d="scan'208";a="245997359"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Matthew Garrett <mjg@redhat.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Feb 2010 13:53:01 -0800
Subject: RE: [E1000-devel] [PATCH v3 1/2] e1000e: Only disable ASPM on
 82573L	devices
Thread-Topic: [E1000-devel] [PATCH v3 1/2] e1000e: Only disable ASPM on
 82573L	devices
Thread-Index: AcqrRkI1o4moLESISEy+ke5eeM8vVgGWQ+qw
Message-ID: <8DD2590731AB5D4C9DBF71A877482A9061394282@orsmsx509.amr.corp.intel.com>
References: <1265912094-4705-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1265912094-4705-1-git-send-email-mjg@redhat.com>
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

On Thursday, February 11, 2010 10:15 AM, Matthew Garrett wrote:
> The 82537 errata and comment in e1000e_disable_l1aspm both agree that
> only 82537L devices are affected. Limit the L1 disable to them.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/net/e1000e/netdev.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> index 57f149b..27eed81 100644
> --- a/drivers/net/e1000e/netdev.c
> +++ b/drivers/net/e1000e/netdev.c
> @@ -4642,6 +4642,10 @@ static void e1000e_disable_l1aspm(struct
> pci_dev *pdev) 
>  	 * Unfortunately this feature saves about 1W power consumption when
>  	 * active.
>  	 */
> +
> +	if (pdev->device != E1000_DEV_ID_82573L)
> +		return;
> +
>  	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
>  	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &val);
>  	if (val & 0x2) {

Hi Matthew,

Exactly which erratum are you referring to?  Erratum 17 in the 82573 Specification Update?  If that is the case, I see the possibility of another interpretation of the erratum which suggests the possibility of the same issue on other variants of the 82573 when using standard frame sizes and ASPM enabled.  Not to mention, I believe there may be other parts (82574 perhaps) that will have issues with L1 ASPM enabled.  I will follow-up with the folks who did the investigation that resulted in the erratum in order to get a clearer picture of all this, and take a look into other parts that may likewise be affected.

Thanks,
Bruce.