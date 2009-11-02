Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZKBSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZKBSGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbZKBSGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:06:34 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1132 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbZKBSGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:06:33 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] cnic: ensure ulp_type is not negative
From: "Michael Chan" <mchan@broadcom.com>
To: "Roel Kluin" <roel.kluin@gmail.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
In-Reply-To: <4AEF0E98.5050304@gmail.com>
References: <4AEF0E98.5050304@gmail.com>
Date: Mon, 2 Nov 2009 09:56:59 -0800
Message-ID: <1257184619.31958.3.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 66F1C0225F4277843-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-11-02 at 08:53 -0800, Roel Kluin wrote:
> `ulp_type' is signed, make sure it is not negative
> when we read the array element.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Looks good to me.  Thanks.
Acked-by: Michael Chan <mchan@broadcom.com>

> ---
>  drivers/net/cnic.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
> index 3bf1b04..f384b0a 100644
> --- a/drivers/net/cnic.c
> +++ b/drivers/net/cnic.c
> @@ -347,7 +347,7 @@ int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops)
>  {
>  	struct cnic_dev *dev;
>  
> -	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
> +	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
>  		printk(KERN_ERR PFX "cnic_register_driver: Bad type %d\n",
>  		       ulp_type);
>  		return -EINVAL;
> @@ -393,7 +393,7 @@ int cnic_unregister_driver(int ulp_type)
>  	struct cnic_ulp_ops *ulp_ops;
>  	int i = 0;
>  
> -	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
> +	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
>  		printk(KERN_ERR PFX "cnic_unregister_driver: Bad type %d\n",
>  		       ulp_type);
>  		return -EINVAL;
> @@ -449,7 +449,7 @@ static int cnic_register_device(struct cnic_dev *dev, int ulp_type,
>  	struct cnic_local *cp = dev->cnic_priv;
>  	struct cnic_ulp_ops *ulp_ops;
>  
> -	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
> +	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
>  		printk(KERN_ERR PFX "cnic_register_device: Bad type %d\n",
>  		       ulp_type);
>  		return -EINVAL;
> @@ -490,7 +490,7 @@ static int cnic_unregister_device(struct cnic_dev *dev, int ulp_type)
>  	struct cnic_local *cp = dev->cnic_priv;
>  	int i = 0;
>  
> -	if (ulp_type >= MAX_CNIC_ULP_TYPE) {
> +	if (ulp_type < 0 || ulp_type >= MAX_CNIC_ULP_TYPE) {
>  		printk(KERN_ERR PFX "cnic_unregister_device: Bad type %d\n",
>  		       ulp_type);
>  		return -EINVAL;
> 


