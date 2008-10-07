Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYJGH6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYJGH6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 03:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYJGH55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 03:57:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYJGH54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 03:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OCKB+UhMVZqSlK0WfhscF9UkNBwhfO8NABklB6ugVJPL7LBLzxMs1vu7rYW/5QC3Q/
         fpU3IhtFXUUDHdr9FY/Lih/qdixgqDU+g4Jcw61sC+JrIhfAiYQCTX4ZpUMN1p9jj7BU
         GCEElazpJiHAXiGHbSgId5ftuly7twOTzPf5M=
Message-ID: <2f1d248c0810070057g3155e1b2x559a72579b55404b@mail.gmail.com>
Date: Tue, 7 Oct 2008 15:57:54 +0800
From: "chen chong" <byrbzdl@gmail.com>
To: pavan_savoy@indiatimes.com
Subject: Re: How to disable authentication when using bluetooth on Linux?
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1254090219.258871223363746800.JavaMail.root@mbv7.indiatimes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f1d248c0810062355r2871da61td3cca6b66a9d77a6@mail.gmail.com>
	 <1254090219.258871223363746800.JavaMail.root@mbv7.indiatimes.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavan

Thanks for your reply. I had tried this before, and tried it again
just now, but it still doesn't work.

The following are my steps, pls help to check if I missed any steps, THX!

1. change "security user;" to "security none;" in /etc/bluetooth/hcid.conf
2. Restart the bluetooth service:  # /etc/init.d/bluetooth restart
3. (Optional: I tried twice, once with this step, and the other without)
    Start passkey-agent: # passkey-agent --default 1234
4. ussp-push --dev 0 --debug 00:01:02:03:04:05@11 desk.jpg desk.jpg  &

root@debian:~/bluetooth#
pushing file desk.jpg
name=desk.jpg, size=24762
__obex_connect: client_context_t = 0x80540f0
Registered transport
Set user data
Created new objext
cobex_write
Local device 00:01:02:03:04:01
Remote device 00:01:02:03:04:05 (11)
Write error: Transport endpoint is not connected
obex_event: client_context_t = 0x80540f0
cobex_disconnect
Link broken!
Started a new request
cobex_close
__obex_connect: error=-2
Unable to connect to the server
Error


my /etc/bluetooth/hcid.conf configuration are as following:
-------------------------------------------------------------------------
# HCId options
options {
        autoinit yes;
        security none;
        pairing multi;
        passkey "1234";
}

# Default settings for HCI devices
device {
        name "pass1234";
        # Local device class
        class 0x3e0100;
        # Default packet type
        #pkt_type DH1,DM1,HV1;
        # Inquiry and Page scan
        iscan enable; pscan enable;
        # Default link mode
        lm accept;
        # Default link policy
        lp rswitch,hold,sniff,park;
}
-------------------------------------------------------------------------

Is this configuration correct?

My Linux version is:
root@debian:~/bluetooth# uname -a
Linux debian 2.6.18-6-686 #1 SMP Sun Feb 10 22:11:31 UTC 2008 i686 GNU/Linux

Any more information needed?

THX


Kris
2008/10/7  <pavan_savoy@indiatimes.com>:
>
> Seems you are using BlueZ -3.37, look in the hcid.conf file in /etc/bluetooth, it should have a keyword "security", make the option to none.
> [I assume its says "user" currently.]
>
>
> Regards,
> Pavan
>
> ----- Original Message -----
> From: chen chong <byrbzdl@gmail.com>
> To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
> Sent: Tue, 7 Oct 2008 12:25:18 +0530 (IST)
> Subject: How to disable authentication when using bluetooth on Linux?
>
> Hi, all
>
> When pushing a file to bluetooth mobile phone from a Linux PC, how to
> disable bluetooth authentication mechanism (in kernel or user level ?
> ), so that the phone won't prompt a window ask for PIN code?
>
>
> I'm a freshman on bluez, now I'm trying to write an application on
> Linux PC,  to send files to mobile phones with OBEX. The PC has a USB
> bluetooth stick to communication with the phone.
>
> Now I have successfully sent a file to phone using the following commands:
> 1. "hcitool scan" and "sdptool browse"
> 2. "passkey-agent --default 1234" and "ussp-push --dev 0
> BTADDR@CHANNEL desk.jpg desk.jpg"
>
> but the phone ask for a PIN code at the start.
>
> To get rid of this, I had tried to comment out
> "start_security_manager()" in bluez-utils-3.7/hcid/main.c,  and
> recompile it, then restart the bluetooth service. But PIN code was
> still prompted, and after if I input some characters,  the command
> "ussp-push --dev 0 --debug  BTADDR@CHANNEL desk.jpg desk.jpg", failed
> with the following error:
>
> root@debian:~/bluetooth# pushing file desk.jpg
> name=desk.jpg, size=24762
> __obex_connect: client_context_t = 0x80540f0
> Registered transport
> Set user data
> Created new objext
> cobex_write
> Local device 00:01:02:03:04:01
> Remote device 00:01:02:03:04:05 (11)
> Write error: Transport endpoint is not connected
> obex_event: client_context_t = 0x80540f0
> cobex_disconnect
> Link broken!
> Started a new request
> cobex_close
> __obex_connect: error=-2
> Unable to connect to the server
> Error
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Will the all new Indica Vista zip ahead of the Suzuki Swift? Read the expert review on Zigwheels.com
> http://zigwheels.com/b2cam/reviewsDetails.action?name=Ro11_20080829&path=/INDT/Reviews/Ro11_20080829&page=1&pagecount=9
>
