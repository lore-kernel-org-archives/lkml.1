Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYL3AZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYL3AZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYL3AZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:25:43 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:37629 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751862AbYL3AZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:25:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3YYyRx1aAD2h5rJlAy5/JxjzVoHz09NgHF3sZR3M0wXq3P97d65yQxflUOucnz/OcIcEK6kVV3k0+PRlL0KuFJz/Pbt4zKCefOMMQ1sZhMjM+fbrs6D7B5xzypYhRVKbESp3dkuZT8ZejCb1XPVKkga0r5BVfXzz+j7gnuWsMUM=  ;
X-YMail-OSG: ola1JKIVM1nlCsfrXlKaEQBgaSOQa_lv10pLToP5sE0zOrY8K.SOw0QnoUmbNTfTp5mkp_deCEJKS6L1IaSWtpJhySeyWn8LwPtHxCPo9zgWzUOGnxZJpzAQU6pPDSDcGPgGFQphiqrIrbPVQrX69ScK8yGy4arqNxZ0dLjc2Rf1IoCBgTBnLWS.Ld9V1JKT_pIG8wMKxdEfHFjmAyjrkAPqL4U-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] include/linux: Move definitions from usb.h to usb/ch9.h
Date: Mon, 29 Dec 2008 16:25:39 -0800
User-Agent: KMail/1.9.10
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812292247300.2265@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812292247300.2265@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291625.39383.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The functions:
> 
> usb_endpoint_dir_in(epd)
> usb_endpoint_dir_out(epd)
> usb_endpoint_is_bulk_in(epd)
> usb_endpoint_is_bulk_out(epd)
> usb_endpoint_is_int_in(epd)
> usb_endpoint_is_int_out(epd)
> usb_endpoint_is_isoc_in(epd)
> usb_endpoint_is_isoc_out(epd)
> usb_endpoint_num(epd)
> usb_endpoint_type(epd)
> usb_endpoint_xfer_bulk(epd)
> usb_endpoint_xfer_control(epd)
> usb_endpoint_xfer_int(epd)
> usb_endpoint_xfer_isoc(epd)
> 
> are moved from include/linux/usb.h to include/linux/usb/ch9.h.
> include/linux/usb/ch9.h makes more sense for these functions because they
> only depend on constants that are defined in this file.

... "constants and structures", to be a bit more exact.  :)


> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
>  include/linux/usb.h     |  180 ------------------------------------------------
>  include/linux/usb/ch9.h |  179 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 179 insertions(+), 180 deletions(-)
> 
> diff -u -p a/include/linux/usb.h b/include/linux/usb.h
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -641,186 +641,6 @@ static inline int usb_make_path(struct u
>  
>  /*-------------------------------------------------------------------------*/
>  
> -/**
> - * usb_endpoint_num - get the endpoint's number
> - * @epd: endpoint to be checked
> - *
> - * Returns @epd's number: 0 to 15.
> - */
> -static inline int usb_endpoint_num(const struct usb_endpoint_descriptor *epd)
> -{
> -	return epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
> -}
> -
> -/**
> - * usb_endpoint_type - get the endpoint's transfer type
> - * @epd: endpoint to be checked
> - *
> - * Returns one of USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT} according
> - * to @epd's transfer type.
> - */
> -static inline int usb_endpoint_type(const struct usb_endpoint_descriptor *epd)
> -{
> -	return epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> -}
> -
> -/**
> - * usb_endpoint_dir_in - check if the endpoint has IN direction
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type IN, otherwise it returns false.
> - */
> -static inline int usb_endpoint_dir_in(const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN);
> -}
> -
> -/**
> - * usb_endpoint_dir_out - check if the endpoint has OUT direction
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type OUT, otherwise it returns false.
> - */
> -static inline int usb_endpoint_dir_out(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT);
> -}
> -
> -/**
> - * usb_endpoint_xfer_bulk - check if the endpoint has bulk transfer type
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type bulk, otherwise it returns false.
> - */
> -static inline int usb_endpoint_xfer_bulk(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> -		USB_ENDPOINT_XFER_BULK);
> -}
> -
> -/**
> - * usb_endpoint_xfer_control - check if the endpoint has control transfer type
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type control, otherwise it returns false.
> - */
> -static inline int usb_endpoint_xfer_control(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> -		USB_ENDPOINT_XFER_CONTROL);
> -}
> -
> -/**
> - * usb_endpoint_xfer_int - check if the endpoint has interrupt transfer type
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type interrupt, otherwise it returns
> - * false.
> - */
> -static inline int usb_endpoint_xfer_int(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> -		USB_ENDPOINT_XFER_INT);
> -}
> -
> -/**
> - * usb_endpoint_xfer_isoc - check if the endpoint has isochronous transfer type
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint is of type isochronous, otherwise it returns
> - * false.
> - */
> -static inline int usb_endpoint_xfer_isoc(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> -		USB_ENDPOINT_XFER_ISOC);
> -}
> -
> -/**
> - * usb_endpoint_is_bulk_in - check if the endpoint is bulk IN
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has bulk transfer type and IN direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_bulk_in(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_in(epd));
> -}
> -
> -/**
> - * usb_endpoint_is_bulk_out - check if the endpoint is bulk OUT
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has bulk transfer type and OUT direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_bulk_out(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_out(epd));
> -}
> -
> -/**
> - * usb_endpoint_is_int_in - check if the endpoint is interrupt IN
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has interrupt transfer type and IN direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_int_in(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd));
> -}
> -
> -/**
> - * usb_endpoint_is_int_out - check if the endpoint is interrupt OUT
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has interrupt transfer type and OUT direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_int_out(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_out(epd));
> -}
> -
> -/**
> - * usb_endpoint_is_isoc_in - check if the endpoint is isochronous IN
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has isochronous transfer type and IN direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_isoc_in(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_isoc(epd) && usb_endpoint_dir_in(epd));
> -}
> -
> -/**
> - * usb_endpoint_is_isoc_out - check if the endpoint is isochronous OUT
> - * @epd: endpoint to be checked
> - *
> - * Returns true if the endpoint has isochronous transfer type and OUT direction,
> - * otherwise it returns false.
> - */
> -static inline int usb_endpoint_is_isoc_out(
> -				const struct usb_endpoint_descriptor *epd)
> -{
> -	return (usb_endpoint_xfer_isoc(epd) && usb_endpoint_dir_out(epd));
> -}
> -
> -/*-------------------------------------------------------------------------*/
> -
>  #define USB_DEVICE_ID_MATCH_DEVICE \
>  		(USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_PRODUCT)
>  #define USB_DEVICE_ID_MATCH_DEV_RANGE \
> diff -u -p a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -353,6 +353,185 @@ struct usb_endpoint_descriptor {
>  #define USB_ENDPOINT_XFER_INT		3
>  #define USB_ENDPOINT_MAX_ADJUSTABLE	0x80
>  
> +/*-------------------------------------------------------------------------*/
> +
> +/**
> + * usb_endpoint_num - get the endpoint's number
> + * @epd: endpoint to be checked
> + *
> + * Returns @epd's number: 0 to 15.
> + */
> +static inline int usb_endpoint_num(const struct usb_endpoint_descriptor *epd)
> +{
> +	return epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
> +}
> +
> +/**
> + * usb_endpoint_type - get the endpoint's transfer type
> + * @epd: endpoint to be checked
> + *
> + * Returns one of USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT} according
> + * to @epd's transfer type.
> + */
> +static inline int usb_endpoint_type(const struct usb_endpoint_descriptor *epd)
> +{
> +	return epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +}
> +
> +/**
> + * usb_endpoint_dir_in - check if the endpoint has IN direction
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type IN, otherwise it returns false.
> + */
> +static inline int usb_endpoint_dir_in(const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN);
> +}
> +
> +/**
> + * usb_endpoint_dir_out - check if the endpoint has OUT direction
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type OUT, otherwise it returns false.
> + */
> +static inline int usb_endpoint_dir_out(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT);
> +}
> +
> +/**
> + * usb_endpoint_xfer_bulk - check if the endpoint has bulk transfer type
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type bulk, otherwise it returns false.
> + */
> +static inline int usb_endpoint_xfer_bulk(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_BULK);
> +}
> +
> +/**
> + * usb_endpoint_xfer_control - check if the endpoint has control transfer type
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type control, otherwise it returns false.
> + */
> +static inline int usb_endpoint_xfer_control(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_CONTROL);
> +}
> +
> +/**
> + * usb_endpoint_xfer_int - check if the endpoint has interrupt transfer type
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type interrupt, otherwise it returns
> + * false.
> + */
> +static inline int usb_endpoint_xfer_int(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_INT);
> +}
> +
> +/**
> + * usb_endpoint_xfer_isoc - check if the endpoint has isochronous transfer type
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint is of type isochronous, otherwise it returns
> + * false.
> + */
> +static inline int usb_endpoint_xfer_isoc(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		USB_ENDPOINT_XFER_ISOC);
> +}
> +
> +/**
> + * usb_endpoint_is_bulk_in - check if the endpoint is bulk IN
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has bulk transfer type and IN direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_bulk_in(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_in(epd));
> +}
> +
> +/**
> + * usb_endpoint_is_bulk_out - check if the endpoint is bulk OUT
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has bulk transfer type and OUT direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_bulk_out(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_out(epd));
> +}
> +
> +/**
> + * usb_endpoint_is_int_in - check if the endpoint is interrupt IN
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has interrupt transfer type and IN direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_int_in(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd));
> +}
> +
> +/**
> + * usb_endpoint_is_int_out - check if the endpoint is interrupt OUT
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has interrupt transfer type and OUT direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_int_out(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_out(epd));
> +}
> +
> +/**
> + * usb_endpoint_is_isoc_in - check if the endpoint is isochronous IN
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has isochronous transfer type and IN direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_isoc_in(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_isoc(epd) && usb_endpoint_dir_in(epd));
> +}
> +
> +/**
> + * usb_endpoint_is_isoc_out - check if the endpoint is isochronous OUT
> + * @epd: endpoint to be checked
> + *
> + * Returns true if the endpoint has isochronous transfer type and OUT direction,
> + * otherwise it returns false.
> + */
> +static inline int usb_endpoint_is_isoc_out(
> +				const struct usb_endpoint_descriptor *epd)
> +{
> +	return (usb_endpoint_xfer_isoc(epd) && usb_endpoint_dir_out(epd));
> +}
>  
>  /*-------------------------------------------------------------------------*/
>  
> 
> 


