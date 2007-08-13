Return-Path: <linux-kernel-owner+w=401wt.eu-S942063AbXHMQMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942063AbXHMQMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947520AbXHMOwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:52:07 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:46390 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S947509AbXHMOwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mP7rNNMZP4a1p9vznEDt9Eibw1V7B71SFn/o+b79XA6emOaciQYbUjJ/xyCWSemf24D2QWGKWqZrrtI234XJzjhQJIYf3xRx0zF+Xg+8+Y+8vegmshSs1ugriduwjjY+lPvf2In5r3KWXfXv8MV7gXnHijNiki11R7FaK5Rbj5Q=
Message-ID: <e1d5030b0708130751if39e36fx303e8cdaae21b927@mail.gmail.com>
Date: Mon, 13 Aug 2007 20:21:58 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: USB HC on i.MX21 hangs with error -110
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

    We are using the i.MX21 Litekit. It has got a USB host port on it
and the driver is imx21-hcd.c provided by the vendor. When I plug in a
USB stick into the host port, the kernel hangs with the following
error:

   usb 1-2: device descriptor read/64, error -110

  I have read on the net that -110 means timeout error. Also there
were suggestions to unload ehci-hcd module. But I do not have ehci-hcd
built into my kernel. My kernel config for USB is:

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB_ARCH_HAS_OHCI is not set
# CONFIG_USB_ARCH_HAS_EHCI is not set
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set



   The kernel boots with the following log on enabling CONFIG_USB_DEBUG.




imx21_hcd_init:1838
imx21_probe:1765
imx21-hc imx21-hc.0: IMX21 USB Host Controller
imx21-hc imx21-hc.0: new USB bus registered, assigned bus number 1
imx21_hc_reset:1430
imx21-hc imx21-hc.0: irq 55, io base 0x00000000
imx21_hc_start:1438
imx21_hc_start:1451
usb usb1: Product: IMX21 USB Host Controller
usb usb1: Manufacturer: Linux 2.6.22 imx21-hc
usb usb1: SerialNumber: imx21-hc.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
imx21_hc_hub_control:1579
  GetHubDescriptor
hub 1-0:1.0: 3 ports detected
imx21_hc_hub_control:1579
  GetHubStatus
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_POWER
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_POWER
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_POWER
>>usb_add_hcd - Exiting without error
imx21_probe:1822
imx21_hc_hub_control:1579
  GetPortStatus: port: 1, 0x100
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x100
imx21_hc_hub_control:1579
  GetPortStatus: port: 3, 0x100





The debug on plugging in the flash drive is:



/ # imx21_hc_hub_status_data:1555
    port 1 (of 3): 0x10101
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x10101
imx21_hc_hub_control:1579
  ClearPortFeature
    USB_PORT_FEAT_C_CONNECTION
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x101
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x101
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x101
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x101
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x101
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_RESET

hwmode     = 0x202000a2  cint_stat  = 0x00000000  cint_sten = 0x00000001
clk_ctrl   = 0x00000003  rst_ctrl   = 0x00000000  frm_intvl = 0x2a2f2edf
frm_remain = 0x28cd0000  hnp_csr   = 0x20440200  hint_isr = 0x00000000
hnp_ien    = 0x00000000  usbctrl    = 0x000f1004

host_ctrl  = 0x00000008  sysisr     = 0x00000004  sysien    = 0x00000000
xbufstat   = 0x00000000  ybufstat   = 0x00000000  xyinten   = 0x00000000
xfillstat  = 0x00000000  yfillstat  = 0x00000000  etdenset  = 0x00000000
etdenclr   = 0x00000000  immedint   = 0x00000000  etddonest = 0x00000000
etddoneen  = 0x00000000  frmnub     = 0x00002f1e  lsthresh  = 0x00000628
roothuba   = 0x01000103  roothubb   = 0x00070000  rootstat  = 0x00000000
portst1    = 0x00000100  portst2    = 0x00000101  portst3   = 0x00000100
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x100103
imx21_hc_hub_control:1579
  ClearPortFeature
    USB_PORT_FEAT_C_RESET
usb 1-2: new full speed USB device using imx21-hc and address 2
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d524a0
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d524a0
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d52500
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d52500
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d52560
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d52560
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_RESET

hwmode     = 0x202000a2  cint_stat  = 0x00000000  cint_sten = 0x00000001
clk_ctrl   = 0x00000003  rst_ctrl   = 0x00000000  frm_intvl = 0x2a2f2edf
frm_remain = 0x06810000  hnp_csr   = 0x20440200  hint_isr = 0x00000000
hnp_ien    = 0x00000000  usbctrl    = 0x000f1004

host_ctrl  = 0x00000008  sysisr     = 0x00000004  sysien    = 0x00000000
xbufstat   = 0x00000000  ybufstat   = 0x00000000  xyinten   = 0x00000000
xfillstat  = 0x00000000  yfillstat  = 0x00000000  etdenset  = 0x00000000
etdenclr   = 0x00000000  immedint   = 0x00000000  etddonest = 0x00000000
etddoneen  = 0x00000001  frmnub     = 0x0000344a  lsthresh  = 0x00000628
roothuba   = 0x01000103  roothubb   = 0x00070000  rootstat  = 0x00000000
portst1    = 0x00000100  portst2    = 0x00000103  portst3   = 0x00000100
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x100103
imx21_hc_hub_control:1579
  ClearPortFeature
    USB_PORT_FEAT_C_RESET
usb 1-2: device descriptor read/64, error -110
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d525c0
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d525c0
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d52620
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d52620
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_urb_enqueue:1466
ep: c2d94034
ep->hcpriv: 00000000
ep->urb_list: c2d94040
ep->descriptor:
    bEndpointAddress: 0
    wMaxPacketSize: 64
urb: c2d52680
   ->dev->speed: FULL
   ->hcpriv: 00000000
   ->pipe: 0x80000080  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
imx21_irq:1403
imx21_irq:1413
etd(0): 0x00400000 0x00400000 0xf0800000 0x07e00008
imx21_irq:1403
imx21_irq:1407
sh_done_list:1176
hc_parse_trans:1036
hc_parse_trans:1039
hc_parse_trans:1043
etd(0): 0x08400000 0x00400000 0x53800000 0x07e00008
hc_parse_trans:1113
hc_parse_trans:1144
hc_parse_trans:1152
urb: c2d52680
   ->dev->speed: FULL
   ->hcpriv: c2d4e160
   ->pipe: 0x80000082  IN  CTRL
   ->transfer_flags: 0x0
   ->transfer_buffer: c2d734a0
   ->transfer_dma: 0xc2d734a0
   ->transfer_buffer_length: 64
   ->setup_packet: c2cb1200
   ->setup_dma: 0xc2cb1200
       0x80 0x06 0x00 0x01 0x00 0x00 0x40 0x00
   maxpacket: 64
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
hc_parse_trans:1036
imx21_irq:1413
imx21_hc_hub_control:1579
  SetPortFeature
    USB_PORT_FEAT_RESET

hwmode     = 0x202000a2  cint_stat  = 0x00000000  cint_sten = 0x00000001
clk_ctrl   = 0x00000003  rst_ctrl   = 0x00000000  frm_intvl = 0x2a2f2edf
frm_remain = 0x082e0000  hnp_csr   = 0x20440200  hint_isr = 0x00000000
hnp_ien    = 0x00000000  usbctrl    = 0x000f1004

host_ctrl  = 0x00000008  sysisr     = 0x00000004  sysien    = 0x00000000
xbufstat   = 0x00000000  ybufstat   = 0x00000000  xyinten   = 0x00000000
xfillstat  = 0x00000000  yfillstat  = 0x00000000  etdenset  = 0x00000000
etdenclr   = 0x00000000  immedint   = 0x00000000  etddonest = 0x00000000
etddoneen  = 0x00000001  frmnub     = 0x00003a5e  lsthresh  = 0x00000628
roothuba   = 0x01000103  roothubb   = 0x00070000  rootstat  = 0x00000000
portst1    = 0x00000100  portst2    = 0x00000103  portst3   = 0x00000100
imx21_hc_hub_control:1579
  GetPortStatus: port: 2, 0x100103
imx21_hc_hub_status_data:1555
    port 1 (of 3): 0x100103
imx21_hc_hub_control:1579
  ClearPortFeature
    USB_PORT_FEAT_C_RESET
usb 1-2: device descriptor read/64, error -110
imx21_hc_hub_control:1579
  ClearPortFeature
    USB_PORT_FEAT_ENABLE


  The host controller has been configured for Full speed only. Should
I change the speed to LOW?


Thanks,
Midhun.
