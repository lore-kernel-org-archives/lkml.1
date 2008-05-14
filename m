Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbYENP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbYENP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYENP6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:58:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34105 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276AbYENP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:58:29 -0400
Date: Wed, 14 May 2008 17:58:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Greg KH <greg@kroah.com>
cc: jgarzik@pobox.com, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSO: add option hso driver
In-Reply-To: <20080513215134.GC6139@kroah.com>
Message-ID: <alpine.LNX.1.10.0805141746150.5292@fbirervta.pbzchgretzou.qr>
References: <20080513215134.GC6139@kroah.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-05-13 23:51, Greg KH wrote:
>+#define MOD_AUTHOR			"Option Wireless"
>+#define MOD_DESCRIPTION			"USB High Speed Option driver"
>+#define MOD_LICENSE			"GPL"
>...
That MODULE_DESCRIPTION(MOD_DESCRIPTION) looks so redundant. [Same
for MOD_AUTHOR and MOD_LICENSE.]
Just write MODULE_DESCRIPTION("USB High Speed Option driver"), no?

Also, "Option" sounds a bit misleading. Is Option a company name,
a product name, or the original English word "option"? It's confusing.

>+struct hso_device {
>+	union {
>+		struct hso_serial *dev_serial;
>+		struct hso_net *dev_net;
>+	} port_data;

This does not really need a name, since it is an anon union anyway.

>+};
>+

The usual bunch of \s.. er, has this gone through checkpatch? [Seems 
mostly clean though.]

>+/* Type of interface */
>+#define HSO_INTF_MASK		0xFF00
>+#define	HSO_INTF_MUX		0x0100
>+#define	HSO_INTF_BULK   	0x0200
>+
>+/* Type of port */
>+#define HSO_PORT_MASK		0xFF
>+#define HSO_PORT_NO_PORT	0x0
>+#define	HSO_PORT_CONTROL	0x1
>+#define	HSO_PORT_APP		0x2
>+#define	HSO_PORT_GPS		0x3
>+#define	HSO_PORT_PCSC		0x4
>+#define	HSO_PORT_APP2		0x5
>+#define HSO_PORT_GPS_CONTROL	0x6
>+#define HSO_PORT_MSD		0x7
>+#define HSO_PORT_VOICE		0x8
>+#define HSO_PORT_DIAG2		0x9
>+#define	HSO_PORT_DIAG		0x10
>+#define	HSO_PORT_MODEM		0x11
>+#define	HSO_PORT_NETWORK	0x12
>+
>+/* Additional device info */
>+#define HSO_INFO_MASK		0xFF000000
>+#define HSO_INFO_CRC_BUG	0x01000000
>+
>+/* Sysfs attribute */
>+static ssize_t hso_sysfs_show_porttype(struct device *dev,
>+				       struct device_attribute *attr,
>+				       char *buf)
>+{
>+	struct hso_device *hso_dev = dev->driver_data;
>+	char *port_name;
	const char *port_name;

>...
>+	case HSO_PORT_DIAG2:
>+		port_name = "Diagnostic2";
>+		break;
>+	case HSO_PORT_MODEM:
>+		port_name = "Modem";
>+		break;
>+	case HSO_PORT_NETWORK:
>+		port_name = "Network";
>+		break;
>+	default:
>+		port_name = "Unknown";
>+		break;
>+	}
>+
>+	return sprintf(buf, "%s\n", port_name);
>+}

You could refactor this using a static array mapping from port to 
string. Same for the following three functions (hso_port_to_mux and 
hso_mux_to_port).

	static const char *const names[] = {
		[HSO_PORT_xxx] = "xxx";
	};

>+static struct ethtool_ops ops = {
const?

>+	.get_drvinfo = hso_get_drvinfo,
>+	.get_link = ethtool_op_get_link
>+};
>+
>+static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
>+{
[...]
>+	/* done */
>+	return;
>+}

I would have never thought! (Also elsewhere.)

